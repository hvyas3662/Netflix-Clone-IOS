import UIKit

struct ThemeManager{
    
    static func applyGlobalTheme(){
        UIButton.appearance().tintColor = UIColor(named: "AccentColor")
    }
}
