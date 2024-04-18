//
//  MyStatsCollectionViewController.swift
//  44643Sec04Team04Spring2024FinalProject
//
//  Created by Yaswanth Kanakala on 3/26/24.
//

import UIKit

struct ApiResponse: Codable {
    let data: [Fixture]
}

struct Fixture: Codable {
    let id: Int
    let name: String
    let statistics: [Statistic]?

    enum CodingKeys: String, CodingKey {
        case id, name, statistics
    }
}

struct Statistic: Codable {
    let id: Int
    let fixtureId: Int
    let participantId: Int
    let value: Int
    let location: String

    enum CodingKeys: String, CodingKey {
        case id, location, value
        case fixtureId = "fixture_id"
        case participantId = "participant_id"
    }
}

class MyStatsClctnVC: UICollectionViewController {
    private var statistics = [Statistic]() // This will hold all statistics
    private let reuseIdentifier = "StatCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchPlayerStatistics()
    }

    func fetchPlayerStatistics() {
        let urlString = "https://api.sportmonks.com/v3/football/fixtures?api_token=uouy8GwevHmCvfsqpdORyBvljVWQeRIIXV6qhyY9aGwJfAcaYfzvnkZcvSCx&include=statistics"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.statistics = apiResponse.data.flatMap { $0.statistics ?? [] }
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        task.resume()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statistics.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }

    func configure(cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let stat = statistics[indexPath.row]
        cell.backgroundColor = .lightGray // Example setup
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true

        // Adding label to cell (for demonstration)
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = "Fixture ID: \(stat.fixtureId), Stat ID: \(stat.id), Value: \(stat.value)"
        label.textAlignment = .center
        cell.contentView.addSubview(label)
    }
}
