//
//  MoviesTableViewCell.swift
//  AllinOne
//
//  Created by Hasat Serinkan on 13.08.2023.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    let movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let movieName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "Futura", size: 18) ?? UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.contentView.backgroundColor = .clear
        
        setupSubViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        [movieImage, movieName].forEach { (item) in
            addSubview(item)
        }
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            movieImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            movieImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            movieImage.widthAnchor.constraint(equalToConstant: 120),
            movieImage.heightAnchor.constraint(equalToConstant: 60),
            
            movieName.leadingAnchor.constraint(equalTo: movieImage.trailingAnchor, constant: 16),
            movieName.centerYAnchor.constraint(equalTo: centerYAnchor),
            movieName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

