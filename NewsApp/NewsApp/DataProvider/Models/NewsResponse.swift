//
//  Article.swift
//  NewsApp
//
//  Created by Atakan Atalar on 18.10.2024.
//

import Foundation

struct NewsResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct Source: Decodable {
    let id: String?
    let name: String?
}

//MARK: - Mock
extension NewsResponse {
    static var mock: NewsResponse {
        return NewsResponse(
            status: "ok",
            totalResults: 4,
            articles: [
                Article.mock,
                Article.mock,
                Article.mock,
                Article.mock,
            ]
        )
    }
}

extension Article {
    static var mock: Article {
        return Article(
            source: Source.mock,
            author: "John Doe",
            title: "Sample News Title 1",
            description: "This is a mock description for the first article.",
            url: "https://example.com/article1",
            urlToImage: "https://example.com/image1.jpg",
            publishedAt: "2024-10-19T12:34:56Z",
            content: "In today's ever-changing world, staying informed is more important than ever. This article delves into the complexities of global events, offering in-depth analysis and expert commentary. The first mock article explores recent developments in technology, finance, and the environment, providing readers with a comprehensive understanding of these pressing issues. The rapid advancements in artificial intelligence, renewable energy technologies, and global financial markets have reshaped the way industries operate. As governments and corporations adjust to these changes, it's crucial for individuals to remain aware of how these trends might impact their daily lives. By examining case studies and expert opinions, this article offers insights into what the future might hold and how we can best prepare for it."
        )
    }
}

extension Source {
    static var mock: Source {
        return Source(id: "source1", name: "Mock News")
    }
}

