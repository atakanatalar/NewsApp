//
//  Constants.swift
//  NewsApp
//
//  Created by Atakan Atalar on 31.10.2024.
//

import Foundation

enum OnboardingViewConstants {
    static let startButtonTitle = String.localized("onboarding_start_button_title")
    static let firstPageTitle = String.localized("onboarding_page_1_title")
    static let firstPageDescription = String.localized("onboarding_page_1_description")
    static let secondPageTitle = String.localized("onboarding_page_2_title")
    static let secondPageDescription = String.localized("onboarding_page_2_description")
    static let thirdPageTitle = String.localized("onboarding_page_3_title")
    static let thirdPageDescription = String.localized("onboarding_page_3_description")
}

enum HomeViewConstants {
    static let title = String.localized("home_title")
    static let searchPlaceholder = String.localized("home_search_placeholder")
    static let tableViewCellID = String.localized("home_table_view_cell_id")
    static let emptyStateMessage = String.localized("home_empty_state_message")
}

enum FavoritesViewConstants {
    static let title = String.localized("favorites_title")
    static let tableViewCellID = String.localized("favorites_table_view_cell_id")
    static let emptyStateMessage = String.localized("favorites_empty_state_message")
}

enum DetailViewConstants {
    static let moreDetailButtonTitle = String.localized("detail_more_detail_button_title")
    static let moreDetailErrorMessage = String.localized("detail_more_error_message")
}

enum NewsTableViewCellConstants {
    static let unknownDateLabel = String.localized("news_cell_unknown_date_label")
    static let unknownSourceLabel = String.localized("news_cell_unknown_source_label")
}

enum ToastConstants {
    static let errorTitle = String.localized("toast_error_title")
}

enum SFSymbolsConstants {
    static let arrow = String.localized("symbol_arrow_right_circle")
    static let newspaper = String.localized("symbol_newspaper")
    static let grid = String.localized("symbol_grid")
    static let magnifyingglass = String.localized("symbol_magnifyingglass")
    static let bookmarkFill = String.localized("symbol_bookmark.fill")
    static let bookmark = String.localized("symbol_bookmark")
    static let safari = String.localized("symbol_safari")
    static let error = String.localized("symbol_exclamationmark.triangle.fill")
}

enum UserDefaultsConstants {
    static let onboardingForKey = String.localized("user_defaults_onboarding_for_key")
}

enum DateHelperConstant {
    static let daysAgo = String.localized("date_helpers_days")
    static let hoursAgo = String.localized("date_helpers_hours")
    static let minutesAgo = String.localized("date_helpers_minutes")
    static let now = String.localized("date_helpers_now")
    static let unknownDate = String.localized("date_helpers_unknown_date")
}

enum NewsCategoryConstants {
    static let general = String.localized("news_category_general")
    static let business = String.localized("news_category_business")
    static let entertainment = String.localized("news_category_entertainment")
    static let health = String.localized("news_category_health")
    static let science = String.localized("news_category_science")
    static let sports = String.localized("news_category_sports")
    static let technology = String.localized("news_category_technology")
}

enum NewsSortOptionConstants {
    static let publishedAt = String.localized("news_sort_option_published_at")
    static let popularity = String.localized("news_sort_option_popularity")
    static let relevancy = String.localized("news_sort_option_relevancy")
}

enum NetworkErrorConstants {
    static let badURL = String.localized("network_error_bad_URL")
    static let requestFailed = String.localized("network_error_request_failed")
    static let decodingError = String.localized("network_error_decoding_error")
}

enum PersistenceErrorConstants {
    static let unableToFavorite = String.localized("persistence_error_unable_to_favorite")
}

enum OpenFavoritesTipConstants {
    static let eventID = String.localized("open_favorites_tip_event_id")
    static let title = String.localized("open_favorites_tip_title")
    static let message = String.localized("open_favorites_tip_message")
}

enum AddFavoriteTipConstants {
    static let eventID = String.localized("add_favorite_tip_event_id")
    static let title = String.localized("add_favorite_tip_title")
    static let message = String.localized("add_favorite_tip_message")
}
