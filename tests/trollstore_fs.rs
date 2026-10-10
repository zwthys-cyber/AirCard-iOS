#[path = "../rust-core/src/trollstore_fs.rs"]
mod trollstore_fs;

use std::{fs, path::PathBuf, time::{SystemTime, UNIX_EPOCH}};

struct Fixture(PathBuf);
impl Fixture {
    fn new() -> Self {
        let root = std::env::temp_dir().join(format!("aircard-test-{}-{}", std::process::id(), SystemTime::now().duration_since(UNIX_EPOCH).unwrap().as_nanos()));
        fs::create_dir_all(&root).unwrap();
        Self(root)
    }
    fn directory(&self, name: &str) -> PathBuf {
        let path = self.0.join(name);
        fs::create_dir_all(&path).unwrap();
        path
    }
}
impl Drop for Fixture {
    fn drop(&mut self) { let _ = fs::remove_dir_all(&self.0); }
}

#[test]
fn replaces_artwork_and_keeps_the_first_original() {
    let fixture = Fixture::new();
    let source = fixture.directory("source");
    let target = fixture.directory("target");
    let backups = fixture.directory("backups");
    fs::write(target.join("art.png"), b"original").unwrap();
    fs::write(source.join("art.png"), b"skin-1").unwrap();
    trollstore_fs::write_directory(&source, &target, &backups).unwrap();
    fs::write(source.join("art.png"), b"skin-2").unwrap();
    trollstore_fs::write_directory(&source, &target, &backups).unwrap();
    assert_eq!(fs::read(target.join("art.png")).unwrap(), b"skin-2");
    assert_eq!(fs::read(backups.join(target.strip_prefix("/").unwrap()).join("art.png")).unwrap(), b"original");
}

#[test]
fn merges_descriptor_trees_without_deleting_existing_files() {
    let fixture = Fixture::new();
    let source = fixture.directory("source");
    let target = fixture.directory("target");
    let backups = fixture.directory("backups");
    fs::create_dir_all(source.join("assets")).unwrap();
    fs::write(source.join("assets/wallpaper.png"), b"wallpaper").unwrap();
    fs::write(target.join("keep.plist"), b"keep").unwrap();
    trollstore_fs::inject_folder(&source, &target, "descriptor", &backups).unwrap();
    assert_eq!(fs::read(target.join("descriptor/assets/wallpaper.png")).unwrap(), b"wallpaper");
    assert_eq!(fs::read(target.join("keep.plist")).unwrap(), b"keep");
}

#[test]
fn rejects_destination_traversal_and_source_symlinks() {
    let fixture = Fixture::new();
    let source = fixture.directory("source");
    let target = fixture.directory("target");
    let backups = fixture.directory("backups");
    assert!(trollstore_fs::inject_folder(&source, &target, "../escape", &backups).is_err());
    std::os::unix::fs::symlink(target.join("elsewhere"), source.join("link")).unwrap();
    assert!(trollstore_fs::write_directory(&source, &target, &backups).is_err());
}
