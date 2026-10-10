//! Direct file access for the TrollStore build. Originals stay in Documents.
use std::fs::{self, OpenOptions};
use std::io::{self, Write};
use std::path::{Component, Path};
use std::sync::atomic::{AtomicU64, Ordering};

static NEXT_TEMP: AtomicU64 = AtomicU64::new(0);

fn invalid(message: &str) -> io::Error {
    io::Error::new(io::ErrorKind::InvalidInput, message)
}

pub fn write_directory(source: &Path, target: &Path, backups: &Path) -> io::Result<()> {
    if !target.is_absolute() || target.components().any(|c| c == Component::ParentDir) {
        return Err(invalid("Target must be an absolute path without parent traversal"));
    }
    if fs::symlink_metadata(source)?.file_type().is_symlink() {
        return Err(invalid("Source symlinks are not supported"));
    }
    fs::create_dir_all(target)?;
    for entry in fs::read_dir(source)? {
        let entry = entry?;
        let kind = entry.file_type()?;
        let destination = target.join(entry.file_name());
        if kind.is_symlink() {
            return Err(invalid("Source symlinks are not supported"));
        } else if kind.is_dir() {
            write_directory(&entry.path(), &destination, backups)?;
        } else if kind.is_file() {
            write_file(&entry.path(), &destination, backups)?;
        }
    }
    Ok(())
}

pub fn inject_folder(source: &Path, parent: &Path, name: &str, backups: &Path) -> io::Result<()> {
    let mut components = Path::new(name).components();
    if !matches!(components.next(), Some(Component::Normal(_))) || components.next().is_some() {
        return Err(invalid("Destination name must be a single folder name"));
    }
    write_directory(source, &parent.join(name), backups)
}

fn write_file(source: &Path, target: &Path, backups: &Path) -> io::Result<()> {
    let original = match fs::symlink_metadata(target) {
        Ok(metadata) => {
            if !metadata.is_file() || metadata.file_type().is_symlink() {
                return Err(invalid("Refusing to replace a directory or symlink"));
            }
            let backup = backups.join(target.strip_prefix("/").map_err(|_| invalid("Invalid target"))?);
            if !backup.exists() {
                fs::create_dir_all(backup.parent().ok_or_else(|| invalid("Missing backup parent"))?)?;
                fs::copy(target, backup)?;
            }
            Some(metadata.permissions())
        }
        Err(error) if error.kind() == io::ErrorKind::NotFound => None,
        Err(error) => return Err(error),
    };
    let parent = target.parent().ok_or_else(|| invalid("Missing target parent"))?;
    let temporary = parent.join(format!(".aircard-{}-{}.tmp", std::process::id(), NEXT_TEMP.fetch_add(1, Ordering::Relaxed)));
    let result = (|| {
        let data = fs::read(source)?;
        let mut file = OpenOptions::new().write(true).create_new(true).open(&temporary)?;
        file.write_all(&data)?;
        file.sync_all()?;
        fs::set_permissions(&temporary, original.unwrap_or(fs::metadata(source)?.permissions()))?;
        fs::rename(&temporary, target)?;
        if fs::read(target)? != data {
            return Err(io::Error::other("Written file did not match source"));
        }
        Ok(())
    })();
    if temporary.exists() {
        let _ = fs::remove_file(temporary);
    }
    result
}
