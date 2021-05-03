//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
    fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
    fileprivate static let hostingBundle = Bundle(for: R.Class.self)

    static func validate() throws {
        try intern.validate()
    }

    /// This `R.file` struct is generated, and contains static references to 1 files.
    struct file {
        /// Resource file `GoogleService-Info.plist`.
        static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")

        /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
        static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
            let fileResource = R.file.googleServiceInfoPlist
            return fileResource.bundle.url(forResource: fileResource)
        }

        fileprivate init() {}
    }

    /// This `R.image` struct is generated, and contains static references to 2 images.
    struct image {
        /// Image `account_plus`.
        static let account_plus = Rswift.ImageResource(bundle: R.hostingBundle, name: "account_plus")
        /// Image `back_icon`.
        static let back_icon = Rswift.ImageResource(bundle: R.hostingBundle, name: "back_icon")

        /// `UIImage(named: "account_plus", bundle: ..., traitCollection: ...)`
        static func account_plus(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
            return UIKit.UIImage(resource: R.image.account_plus, compatibleWith: traitCollection)
        }

        /// `UIImage(named: "back_icon", bundle: ..., traitCollection: ...)`
        static func back_icon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
            return UIKit.UIImage(resource: R.image.back_icon, compatibleWith: traitCollection)
        }

        fileprivate init() {}
    }

    /// This `R.nib` struct is generated, and contains static references to 6 nibs.
    struct nib {
        /// Nib `CreateSearchTableViewHeader`.
        static let createSearchTableViewHeader = _R.nib._CreateSearchTableViewHeader()
        /// Nib `ExpenseTableViewCell`.
        static let expenseTableViewCell = _R.nib._ExpenseTableViewCell()
        /// Nib `ExpenseTableViewHeader`.
        static let expenseTableViewHeader = _R.nib._ExpenseTableViewHeader()
        /// Nib `RightTextFieldTableViewCell`.
        static let rightTextFieldTableViewCell = _R.nib._RightTextFieldTableViewCell()
        /// Nib `TextFieldErrorMessage`.
        static let textFieldErrorMessage = _R.nib._TextFieldErrorMessage()
        /// Nib `ValidationTextField`.
        static let validationTextField = _R.nib._ValidationTextField()

        /// `UINib(name: "CreateSearchTableViewHeader", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.createSearchTableViewHeader) instead")
        static func createSearchTableViewHeader(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.createSearchTableViewHeader)
        }

        /// `UINib(name: "ExpenseTableViewCell", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.expenseTableViewCell) instead")
        static func expenseTableViewCell(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.expenseTableViewCell)
        }

        /// `UINib(name: "ExpenseTableViewHeader", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.expenseTableViewHeader) instead")
        static func expenseTableViewHeader(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.expenseTableViewHeader)
        }

        /// `UINib(name: "RightTextFieldTableViewCell", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.rightTextFieldTableViewCell) instead")
        static func rightTextFieldTableViewCell(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.rightTextFieldTableViewCell)
        }

        /// `UINib(name: "TextFieldErrorMessage", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.textFieldErrorMessage) instead")
        static func textFieldErrorMessage(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.textFieldErrorMessage)
        }

        /// `UINib(name: "ValidationTextField", in: bundle)`
        @available(*, deprecated, message: "Use UINib(resource: R.nib.validationTextField) instead")
        static func validationTextField(_: Void = ()) -> UIKit.UINib {
            return UIKit.UINib(resource: R.nib.validationTextField)
        }

        static func createSearchTableViewHeader(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> CreateSearchTableViewHeader? {
            return R.nib.createSearchTableViewHeader.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CreateSearchTableViewHeader
        }

        static func expenseTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> ExpenseTableViewCell? {
            return R.nib.expenseTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ExpenseTableViewCell
        }

        static func expenseTableViewHeader(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> ExpenseTableViewHeader? {
            return R.nib.expenseTableViewHeader.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ExpenseTableViewHeader
        }

        static func rightTextFieldTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> RightTextFieldTableViewCell? {
            return R.nib.rightTextFieldTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? RightTextFieldTableViewCell
        }

        static func textFieldErrorMessage(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> TextFieldErrorMessage? {
            return R.nib.textFieldErrorMessage.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TextFieldErrorMessage
        }

        static func validationTextField(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> ValidationTextField? {
            return R.nib.validationTextField.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ValidationTextField
        }

        fileprivate init() {}
    }

    /// This `R.reuseIdentifier` struct is generated, and contains static references to 3 reuse identifiers.
    struct reuseIdentifier {
        /// Reuse identifier `ExpenseTableViewCell`.
        static let expenseTableViewCell: Rswift.ReuseIdentifier<ExpenseTableViewCell> = Rswift.ReuseIdentifier(identifier: "ExpenseTableViewCell")
        /// Reuse identifier `RightTextFieldTableViewCell`.
        static let rightTextFieldTableViewCell: Rswift.ReuseIdentifier<RightTextFieldTableViewCell> = Rswift.ReuseIdentifier(identifier: "RightTextFieldTableViewCell")
        /// Reuse identifier `TeamMemberTableViewCell`.
        static let teamMemberTableViewCell: Rswift.ReuseIdentifier<UIKit.UITableViewCell> = Rswift.ReuseIdentifier(identifier: "TeamMemberTableViewCell")

        fileprivate init() {}
    }

    /// This `R.storyboard` struct is generated, and contains static references to 2 storyboards.
    struct storyboard {
        /// Storyboard `LaunchScreen`.
        static let launchScreen = _R.storyboard.launchScreen()
        /// Storyboard `Main`.
        static let main = _R.storyboard.main()

        /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
        static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
            return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
        }

        /// `UIStoryboard(name: "Main", bundle: ...)`
        static func main(_: Void = ()) -> UIKit.UIStoryboard {
            return UIKit.UIStoryboard(resource: R.storyboard.main)
        }

        fileprivate init() {}
    }

    /// This `R.string` struct is generated, and contains static references to 4 localization tables.
    struct string {
        /// This `R.string.infoPlist` struct is generated, and contains static references to 0 localization keys.
        struct infoPlist {
            fileprivate init() {}
        }

        /// This `R.string.launchScreen` struct is generated, and contains static references to 0 localization keys.
        struct launchScreen {
            fileprivate init() {}
        }

        /// This `R.string.localizable` struct is generated, and contains static references to 1 localization keys.
        struct localizable {
            /// ru translation: E-mail не верный
            ///
            /// Locales: ru
            static let eMailIsWrong = Rswift.StringResource(key: "E-mail is wrong", tableName: "Localizable", bundle: R.hostingBundle, locales: ["ru"], comment: nil)

            /// ru translation: E-mail не верный
            ///
            /// Locales: ru
            static func eMailIsWrong(_: Void = ()) -> String {
                return NSLocalizedString("E-mail is wrong", bundle: R.hostingBundle, comment: "")
            }

            fileprivate init() {}
        }

        /// This `R.string.main` struct is generated, and contains static references to 26 localization keys.
        struct main {
            /// en translation: +
            ///
            /// Locales: en
            static let wu6bBhXText = Rswift.StringResource(key: "2WU-6b-bhX.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: -
            ///
            /// Locales: en
            static let pmUSvRBbText = Rswift.StringResource(key: "PmU-Sv-rBb.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: 1000
            ///
            /// Locales: en
            static let iifvm23DText = Rswift.StringResource(key: "IIF-vM-23D.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: 135.37
            ///
            /// Locales: en
            static let uctMiMIkText = Rswift.StringResource(key: "uct-mi-mIk.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: 400
            ///
            /// Locales: en
            static let jv6OyCZfText = Rswift.StringResource(key: "JV6-Oy-cZf.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: 600
            ///
            /// Locales: en
            static let bTJ9AMilText = Rswift.StringResource(key: "bTJ-9A-mil.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: =
            ///
            /// Locales: en
            static let lk1A8RHuText = Rswift.StringResource(key: "Lk1-A8-rHu.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Balance
            ///
            /// Locales: en
            static let pfdMdQTFText = Rswift.StringResource(key: "pfd-Md-qTF.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Budget
            ///
            /// Locales: en
            static let h3zLEHpvText = Rswift.StringResource(key: "h3z-lE-hpv.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Detail
            ///
            /// Locales: en
            static let dZHJJGText = Rswift.StringResource(key: "27d-zH-jJG.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Expenses
            ///
            /// Locales: en
            static let x1Cf8EaText = Rswift.StringResource(key: "6x1-Cf-8Ea.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Feb 2017
            ///
            /// Locales: en
            static let ecDGCN56Text = Rswift.StringResource(key: "ecD-GC-n56.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Item
            ///
            /// Locales: en
            static let yj1PUSR9Title = Rswift.StringResource(key: "yj1-pU-SR9.title", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Log out
            ///
            /// Locales: en
            static let zpTXkOtyNormalTitle = Rswift.StringResource(key: "zpT-Xk-Oty.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Press "+" to create new group
            ///
            /// Locales: en
            static let sfKUeG2lText = Rswift.StringResource(key: "SfK-Ue-g2l.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Reset
            ///
            /// Locales: en
            static let a2LEFOoiNormalTitle = Rswift.StringResource(key: "a2L-eF-Ooi.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Title
            ///
            /// Locales: en
            static let co10RDRText = Rswift.StringResource(key: "8co-10-RDR.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// en translation: Title
            ///
            /// Locales: en
            static let msfUMCb5Text = Rswift.StringResource(key: "msf-UM-cb5.text", tableName: "Main", bundle: R.hostingBundle, locales: ["en"], comment: nil)
            /// uk translation: E-mail
            ///
            /// Locales: uk, ru
            static let u32N6QUoPlaceholder = Rswift.StringResource(key: "u32-n6-qUo.placeholder", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)
            /// uk translation: First Name
            ///
            /// Locales: uk, ru
            static let teZJsTjrPlaceholder = Rswift.StringResource(key: "TeZ-js-Tjr.placeholder", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)
            /// uk translation: Item
            ///
            /// Locales: uk, ru, en
            static let y1YVYAhOTitle = Rswift.StringResource(key: "Y1Y-vY-AhO.title", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru", "en"], comment: nil)
            /// uk translation: Last Name
            ///
            /// Locales: uk, ru
            static let o3nHBYUTPlaceholder = Rswift.StringResource(key: "O3n-HB-yUT.placeholder", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)
            /// uk translation: Login
            ///
            /// Locales: uk, ru
            static let zlUyF5uNormalTitle = Rswift.StringResource(key: "3ZL-Uy-f5u.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)
            /// uk translation: Password
            ///
            /// Locales: uk, ru
            static let zLn2LMRKPlaceholder = Rswift.StringResource(key: "ZLn-2L-mRK.placeholder", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)
            /// uk translation: Repeat Password
            ///
            /// Locales: uk, ru
            static let bum9XSWsPlaceholder = Rswift.StringResource(key: "bum-9X-SWs.placeholder", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)
            /// uk translation: Switch
            ///
            /// Locales: uk, ru
            static let bvs9GOI0NormalTitle = Rswift.StringResource(key: "Bvs-9G-OI0.normalTitle", tableName: "Main", bundle: R.hostingBundle, locales: ["uk", "ru"], comment: nil)

            /// en translation: +
            ///
            /// Locales: en
            static func wu6bBhXText(_: Void = ()) -> String {
                return NSLocalizedString("2WU-6b-bhX.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: -
            ///
            /// Locales: en
            static func pmUSvRBbText(_: Void = ()) -> String {
                return NSLocalizedString("PmU-Sv-rBb.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: 1000
            ///
            /// Locales: en
            static func iifvm23DText(_: Void = ()) -> String {
                return NSLocalizedString("IIF-vM-23D.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: 135.37
            ///
            /// Locales: en
            static func uctMiMIkText(_: Void = ()) -> String {
                return NSLocalizedString("uct-mi-mIk.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: 400
            ///
            /// Locales: en
            static func jv6OyCZfText(_: Void = ()) -> String {
                return NSLocalizedString("JV6-Oy-cZf.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: 600
            ///
            /// Locales: en
            static func bTJ9AMilText(_: Void = ()) -> String {
                return NSLocalizedString("bTJ-9A-mil.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: =
            ///
            /// Locales: en
            static func lk1A8RHuText(_: Void = ()) -> String {
                return NSLocalizedString("Lk1-A8-rHu.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Balance
            ///
            /// Locales: en
            static func pfdMdQTFText(_: Void = ()) -> String {
                return NSLocalizedString("pfd-Md-qTF.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Budget
            ///
            /// Locales: en
            static func h3zLEHpvText(_: Void = ()) -> String {
                return NSLocalizedString("h3z-lE-hpv.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Detail
            ///
            /// Locales: en
            static func dZHJJGText(_: Void = ()) -> String {
                return NSLocalizedString("27d-zH-jJG.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Expenses
            ///
            /// Locales: en
            static func x1Cf8EaText(_: Void = ()) -> String {
                return NSLocalizedString("6x1-Cf-8Ea.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Feb 2017
            ///
            /// Locales: en
            static func ecDGCN56Text(_: Void = ()) -> String {
                return NSLocalizedString("ecD-GC-n56.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Item
            ///
            /// Locales: en
            static func yj1PUSR9Title(_: Void = ()) -> String {
                return NSLocalizedString("yj1-pU-SR9.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Log out
            ///
            /// Locales: en
            static func zpTXkOtyNormalTitle(_: Void = ()) -> String {
                return NSLocalizedString("zpT-Xk-Oty.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Press "+" to create new group
            ///
            /// Locales: en
            static func sfKUeG2lText(_: Void = ()) -> String {
                return NSLocalizedString("SfK-Ue-g2l.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Reset
            ///
            /// Locales: en
            static func a2LEFOoiNormalTitle(_: Void = ()) -> String {
                return NSLocalizedString("a2L-eF-Ooi.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Title
            ///
            /// Locales: en
            static func co10RDRText(_: Void = ()) -> String {
                return NSLocalizedString("8co-10-RDR.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// en translation: Title
            ///
            /// Locales: en
            static func msfUMCb5Text(_: Void = ()) -> String {
                return NSLocalizedString("msf-UM-cb5.text", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: E-mail
            ///
            /// Locales: uk, ru
            static func u32N6QUoPlaceholder(_: Void = ()) -> String {
                return NSLocalizedString("u32-n6-qUo.placeholder", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: First Name
            ///
            /// Locales: uk, ru
            static func teZJsTjrPlaceholder(_: Void = ()) -> String {
                return NSLocalizedString("TeZ-js-Tjr.placeholder", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: Item
            ///
            /// Locales: uk, ru, en
            static func y1YVYAhOTitle(_: Void = ()) -> String {
                return NSLocalizedString("Y1Y-vY-AhO.title", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: Last Name
            ///
            /// Locales: uk, ru
            static func o3nHBYUTPlaceholder(_: Void = ()) -> String {
                return NSLocalizedString("O3n-HB-yUT.placeholder", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: Login
            ///
            /// Locales: uk, ru
            static func zlUyF5uNormalTitle(_: Void = ()) -> String {
                return NSLocalizedString("3ZL-Uy-f5u.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: Password
            ///
            /// Locales: uk, ru
            static func zLn2LMRKPlaceholder(_: Void = ()) -> String {
                return NSLocalizedString("ZLn-2L-mRK.placeholder", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: Repeat Password
            ///
            /// Locales: uk, ru
            static func bum9XSWsPlaceholder(_: Void = ()) -> String {
                return NSLocalizedString("bum-9X-SWs.placeholder", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            /// uk translation: Switch
            ///
            /// Locales: uk, ru
            static func bvs9GOI0NormalTitle(_: Void = ()) -> String {
                return NSLocalizedString("Bvs-9G-OI0.normalTitle", tableName: "Main", bundle: R.hostingBundle, comment: "")
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    fileprivate struct intern: Rswift.Validatable {
        fileprivate static func validate() throws {
            try _R.validate()
        }

        fileprivate init() {}
    }

    fileprivate class Class {}

    fileprivate init() {}
}

struct _R: Rswift.Validatable {
    static func validate() throws {
        try storyboard.validate()
    }

    struct nib {
        struct _CreateSearchTableViewHeader: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "CreateSearchTableViewHeader"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> CreateSearchTableViewHeader? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? CreateSearchTableViewHeader
            }

            fileprivate init() {}
        }

        struct _ExpenseTableViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
            typealias ReusableType = ExpenseTableViewCell

            let bundle = R.hostingBundle
            let identifier = "ExpenseTableViewCell"
            let name = "ExpenseTableViewCell"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> ExpenseTableViewCell? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ExpenseTableViewCell
            }

            fileprivate init() {}
        }

        struct _ExpenseTableViewHeader: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "ExpenseTableViewHeader"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> ExpenseTableViewHeader? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ExpenseTableViewHeader
            }

            fileprivate init() {}
        }

        struct _RightTextFieldTableViewCell: Rswift.NibResourceType, Rswift.ReuseIdentifierType {
            typealias ReusableType = RightTextFieldTableViewCell

            let bundle = R.hostingBundle
            let identifier = "RightTextFieldTableViewCell"
            let name = "RightTextFieldTableViewCell"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> RightTextFieldTableViewCell? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? RightTextFieldTableViewCell
            }

            fileprivate init() {}
        }

        struct _TextFieldErrorMessage: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "TextFieldErrorMessage"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> TextFieldErrorMessage? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? TextFieldErrorMessage
            }

            fileprivate init() {}
        }

        struct _ValidationTextField: Rswift.NibResourceType {
            let bundle = R.hostingBundle
            let name = "ValidationTextField"

            func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey: Any]? = nil) -> ValidationTextField? {
                return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? ValidationTextField
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    struct storyboard: Rswift.Validatable {
        static func validate() throws {
            try launchScreen.validate()
            try main.validate()
        }

        struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
            typealias InitialController = UIKit.UIViewController

            let bundle = R.hostingBundle
            let name = "LaunchScreen"

            static func validate() throws {
                if #available(iOS 11.0, *) {}
            }

            fileprivate init() {}
        }

        struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
            typealias InitialController = RotateTabBarController

            let budgetDetailViewController = StoryboardViewControllerResource<BudgetDetailViewController>(identifier: "BudgetDetailViewController")
            let budgetViewController = StoryboardViewControllerResource<BudgetViewController>(identifier: "BudgetViewController")
            let bundle = R.hostingBundle
            let categoryViewController = StoryboardViewControllerResource<CategoryViewController>(identifier: "CategoryViewController")
            let editExpenseViewController = StoryboardViewControllerResource<EditExpenseViewController>(identifier: "EditExpenseViewController")
            let expensesViewController = StoryboardViewControllerResource<ExpensesViewController>(identifier: "ExpensesViewController")
            let loginNavigationViewController = StoryboardViewControllerResource<RotateNavigationController>(identifier: "LoginNavigationViewController")
            let loginViewController = StoryboardViewControllerResource<LoginViewController>(identifier: "LoginViewController")
            let name = "Main"
            let teamMembersViewController = StoryboardViewControllerResource<TeamMembersViewController>(identifier: "TeamMembersViewController")

            func budgetDetailViewController(_: Void = ()) -> BudgetDetailViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: budgetDetailViewController)
            }

            func budgetViewController(_: Void = ()) -> BudgetViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: budgetViewController)
            }

            func categoryViewController(_: Void = ()) -> CategoryViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: categoryViewController)
            }

            func editExpenseViewController(_: Void = ()) -> EditExpenseViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: editExpenseViewController)
            }

            func expensesViewController(_: Void = ()) -> ExpensesViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: expensesViewController)
            }

            func loginNavigationViewController(_: Void = ()) -> RotateNavigationController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginNavigationViewController)
            }

            func loginViewController(_: Void = ()) -> LoginViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginViewController)
            }

            func teamMembersViewController(_: Void = ()) -> TeamMembersViewController? {
                return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: teamMembersViewController)
            }

            static func validate() throws {
                if UIKit.UIImage(named: "account_plus", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'account_plus' is used in storyboard 'Main', but couldn't be loaded.") }
                if UIKit.UIImage(named: "back_icon", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'back_icon' is used in storyboard 'Main', but couldn't be loaded.") }
                if #available(iOS 11.0, *) {}
                if _R.storyboard.main().budgetDetailViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'budgetDetailViewController' could not be loaded from storyboard 'Main' as 'BudgetDetailViewController'.") }
                if _R.storyboard.main().budgetViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'budgetViewController' could not be loaded from storyboard 'Main' as 'BudgetViewController'.") }
                if _R.storyboard.main().categoryViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'categoryViewController' could not be loaded from storyboard 'Main' as 'CategoryViewController'.") }
                if _R.storyboard.main().editExpenseViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'editExpenseViewController' could not be loaded from storyboard 'Main' as 'EditExpenseViewController'.") }
                if _R.storyboard.main().expensesViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'expensesViewController' could not be loaded from storyboard 'Main' as 'ExpensesViewController'.") }
                if _R.storyboard.main().loginNavigationViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'loginNavigationViewController' could not be loaded from storyboard 'Main' as 'RotateNavigationController'.") }
                if _R.storyboard.main().loginViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'loginViewController' could not be loaded from storyboard 'Main' as 'LoginViewController'.") }
                if _R.storyboard.main().teamMembersViewController() == nil { throw Rswift.ValidationError(description: "[R.swift] ViewController with identifier 'teamMembersViewController' could not be loaded from storyboard 'Main' as 'TeamMembersViewController'.") }
            }

            fileprivate init() {}
        }

        fileprivate init() {}
    }

    fileprivate init() {}
}