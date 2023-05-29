//
//  ProfileViewController.swift
//  ToDo
//
//  Created by Apple Macbook on 27/05/2023.
//

import Cocoa
import RealmSwift

class ProfileViewController : NSViewController {
    private var coverPhotoImageView: NSImageView!
    private var profilePhotoImageView: NSImageView!
    private var userNameLabel: NSTextField!
    
    private var viewModel = ProfileViewModel()
        
    private var senderEmail : String  = ""
    private var filteredObj : Results<Profile>?
    
    override func loadView() {
        self.view = NSView()
        view.wantsLayer = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setBinder()
        viewModel.fetchEmail()
        setUpViews()
        checkIfLocalDataExists()
        checkNeedForCloud()
    }
    
    //MARK: - sync database and setting binders
    
    private func setBinder() {
        viewModel.email.bind { [weak self] comingEmail in
            guard let self else { return }
            self.senderEmail = comingEmail
        }
        viewModel.userProfileData.bind { [weak self] comingData in
            guard let self else { return }
            self.filteredObj = comingData
            if let back = self.filteredObj?.first?.background ,
               let front = self.filteredObj?.first?.profile  {
                self.coverPhotoImageView.image = NSImage(data: (back as Data))
                self.profilePhotoImageView.image = NSImage(data: (front as Data))
            }
        }
    }
    
    private func checkIfLocalDataExists(){
        viewModel.loadProfileLocally(forEmail: senderEmail)
    }
    
    private func checkNeedForCloud(){
        if filteredObj?.count == 0 {
            viewModel.loadProfileFromFirebase(forEmail: senderEmail)
        }
    }
        
    override func viewDidLayout() {
        super.viewDidLayout()
        profilePhotoImageView.layer?.cornerRadius = profilePhotoImageView.frame.size.width / 2.0
    }
    
    private func setUpViews() {
        coverPhotoImageView = ProfilePhotoImageView()
        let coverPhotoTapGesture = NSClickGestureRecognizer(target: self, action: #selector(openCoverPhotoPicker(_:)))
        coverPhotoImageView.addGestureRecognizer(coverPhotoTapGesture)
        coverPhotoImageView.image = NSImage(named: "PGWelcome")

        profilePhotoImageView = ProfilePhotoImageView()
        let profilePhotoTapGesture = NSClickGestureRecognizer(target: self, action: #selector(openProfilePhotoPicker(_:)))
        profilePhotoImageView.addGestureRecognizer(profilePhotoTapGesture)
        profilePhotoImageView.wantsLayer = true
        profilePhotoImageView.layer?.borderWidth = 2.0
        profilePhotoImageView.layer?.borderColor = NSColor.white.cgColor
        profilePhotoImageView.image = NSImage(named: "PGWelcome")

        
        userNameLabel = ProfileLabelView()
        userNameLabel.stringValue = viewModel.fetchUserNameForCurrentSession()
        userNameLabel.font = NSFont.systemFont(ofSize: 13)

        view.addSubview(coverPhotoImageView)
        view.addSubview(profilePhotoImageView)
        view.addSubview(userNameLabel)
        
        coverPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        profilePhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverPhotoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverPhotoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverPhotoImageView.heightAnchor.constraint(equalToConstant: 70),
            coverPhotoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            
            profilePhotoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profilePhotoImageView.heightAnchor.constraint(equalToConstant: 40),
            profilePhotoImageView.widthAnchor.constraint(equalToConstant: 40),
            profilePhotoImageView.topAnchor.constraint(equalTo: coverPhotoImageView.bottomAnchor,constant: -20),
            
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: 200),
            userNameLabel.topAnchor.constraint(equalTo: profilePhotoImageView.bottomAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }
}



extension ProfileViewController : NSOpenSavePanelDelegate {
    
    @objc private func openCoverPhotoPicker(_ sender: Any) {
        viewModel.openImagePicker(for: coverPhotoImageView, type: .cover)
    }
    
    @objc private func openProfilePhotoPicker(_ sender: Any) {
        viewModel.openImagePicker(for: profilePhotoImageView, type: .profile)
    }
}




