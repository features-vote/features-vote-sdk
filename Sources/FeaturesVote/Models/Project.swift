import Foundation

/// Public project configuration and customization
public struct Project: Codable {
    public let name: String
    public let slug: String
    public let primaryLight: String
    public let primaryDark: String
    public let logoUrl: String
    public let websiteUrl: String
    public let colorMode: String?
    public let customization: Customization

    enum CodingKeys: String, CodingKey {
        case name
        case slug
        case primaryLight = "primary_light"
        case primaryDark = "primary_dark"
        case logoUrl = "logo_url"
        case websiteUrl = "website_url"
        case colorMode = "color_mode"
        case customization
    }

    public init(
        name: String,
        slug: String,
        primaryLight: String,
        primaryDark: String,
        logoUrl: String,
        websiteUrl: String,
        colorMode: String? = nil,
        customization: Customization
    ) {
        self.name = name
        self.slug = slug
        self.primaryLight = primaryLight
        self.primaryDark = primaryDark
        self.logoUrl = logoUrl
        self.websiteUrl = websiteUrl
        self.colorMode = colorMode
        self.customization = customization
    }
}

/// Project-specific customization settings
public struct Customization: Codable {
    public let tags: [Tag]?
    public let hideWatermark: Bool?
    public let votingBoardTitle: String?
    public let isAnonDisabled: Bool?
    public let isPrivateBoard: Bool?
    public let isTokenOnly: Bool?
    public let suggestPopupSuccessMsg: String?
    public let suggestPopupHeaderText: String?
    public let isInProgressOnTop: Bool?
    public let viewAllRequestsLink: String?
    public let postLabel: String?
    public let roadmapLabel: String?
    public let changelogLabel: String?
    public let hideViewAllRedirect: Bool?
    public let disabledAnonMessage: String?
    public let whitelistUrls: String?
    public let defaultLanguage: String?
    public let showTranslations: Bool?

    enum CodingKeys: String, CodingKey {
        case tags
        case hideWatermark
        case votingBoardTitle
        case isAnonDisabled = "is_anon_disabled"
        case isPrivateBoard = "is_private_board"
        case isTokenOnly = "is_token_only"
        case suggestPopupSuccessMsg
        case suggestPopupHeaderText
        case isInProgressOnTop
        case viewAllRequestsLink
        case postLabel
        case roadmapLabel
        case changelogLabel
        case hideViewAllRedirect
        case disabledAnonMessage
        case whitelistUrls
        case defaultLanguage
        case showTranslations
    }

    public init(
        tags: [Tag]? = nil,
        hideWatermark: Bool? = nil,
        votingBoardTitle: String? = nil,
        isAnonDisabled: Bool? = nil,
        isPrivateBoard: Bool? = nil,
        isTokenOnly: Bool? = nil,
        suggestPopupSuccessMsg: String? = nil,
        suggestPopupHeaderText: String? = nil,
        isInProgressOnTop: Bool? = nil,
        viewAllRequestsLink: String? = nil,
        postLabel: String? = nil,
        roadmapLabel: String? = nil,
        changelogLabel: String? = nil,
        hideViewAllRedirect: Bool? = nil,
        disabledAnonMessage: String? = nil,
        whitelistUrls: String? = nil,
        defaultLanguage: String? = nil,
        showTranslations: Bool? = nil
    ) {
        self.tags = tags
        self.hideWatermark = hideWatermark
        self.votingBoardTitle = votingBoardTitle
        self.isAnonDisabled = isAnonDisabled
        self.isPrivateBoard = isPrivateBoard
        self.isTokenOnly = isTokenOnly
        self.suggestPopupSuccessMsg = suggestPopupSuccessMsg
        self.suggestPopupHeaderText = suggestPopupHeaderText
        self.isInProgressOnTop = isInProgressOnTop
        self.viewAllRequestsLink = viewAllRequestsLink
        self.postLabel = postLabel
        self.roadmapLabel = roadmapLabel
        self.changelogLabel = changelogLabel
        self.hideViewAllRedirect = hideViewAllRedirect
        self.disabledAnonMessage = disabledAnonMessage
        self.whitelistUrls = whitelistUrls
        self.defaultLanguage = defaultLanguage
        self.showTranslations = showTranslations
    }
}
