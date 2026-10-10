import Foundation

enum ChineseTitles {
    static let values: [String: String] = [
        "Apply .passthm": "应用 .passthm 主题",
        "Create Theme": "创建主题",
        "Poster Slice": "整体背景切片",
        "Individual Keys": "独立按键",
        "All Languages (Universal)": "所有语言（通用）",
        "Ukrainian (uk)": "乌克兰语（uk）",
        "Russian (ru)": "俄语（ru）",
        "English (en)": "英语（en）",
        "Other / Fallback": "其他／备用",
        "Spanish (es)": "西班牙语（es）",
        "German (de)": "德语（de）",
        "French (fr)": "法语（fr）",
        "Polish (pl)": "波兰语（pl）",
        "Italian (it)": "意大利语（it）",
        "Portuguese (pt)": "葡萄牙语（pt）",
        "Turkish (tr)": "土耳其语（tr）",
        "Japanese (ja)": "日语（ja）",
        "Korean (ko)": "韩语（ko）",
        "Chinese (zh)": "中文（zh）",
        "Arabic (ar)": "阿拉伯语（ar）",
        "Hebrew (he)": "希伯来语（he）",
        "Universal (Regular + Bold)": "通用（常规＋粗体）",
        "Bold Text Only (Fast)": "仅粗体（快速）",
        "Regular Font Only (Fast)": "仅常规字体（快速）",
        "Collections": "精选壁纸",
        "Suggested Photos": "推荐照片",
        "Mercury": "Mercury 动态壁纸",
        "App Container": "应用容器",
        "UnionPay": "银联",
        "Mastercard": "万事达",
        "American Express": "美国运通",
    ]

    static func title(_ value: String) -> String { values[value] ?? value }
}

extension CreatorMode {
    var displayTitle: String { ChineseTitles.title(rawValue) }
}
extension SliceMode {
    var displayTitle: String { ChineseTitles.title(rawValue) }
}
extension PasscodeLanguageTarget {
    var displayTitle: String { ChineseTitles.title(rawValue) }
}
extension PasscodeBoldTarget {
    var displayTitle: String { ChineseTitles.title(rawValue) }
}
extension TendiePosterType {
    var displayTitle: String { ChineseTitles.title(rawValue) }
}
