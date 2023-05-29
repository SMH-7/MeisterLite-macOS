//
//  ProfileViewModel.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import AppKit
import Firebase
import RealmSwift

class ProfileViewModel: BaseViewModel {
    
    
    private let realmService = RealmManager<Profile>()
    private let firebaseService = FirebaseManager<Profile>()
    
    lazy var userProfileData = Binder< Results<Profile> >(realm.objects(Profile.self))
    lazy var email = Binder<String>("")
    lazy var error = Binder<String>("")
    
    
    override init() {
        super.init()
        realmService.fetchedObjects.bind { [weak self] localData in
            guard let self else { return }
            self.userProfileData.value = localData
        }
        realmService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        firebaseService.email.bind { [weak self] comingMail in
            guard let self else { return }
            self.email.value = comingMail
        }
        firebaseService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        
    }
    
    func openImagePicker(for imageView: NSImageView, type: imagePicker) {
        let imagePicker = NSOpenPanel()
        imagePicker.allowedFileTypes = ["public.image"]
        
        imagePicker.begin { [weak self] response in
            guard let self else { return }
            guard response == .OK, let imageURL = imagePicker.urls.first else {
                return
            }
            if let image = NSImage(contentsOf: imageURL) {
                let temp = type == .profile ? true : false

                self.ModifyFireBaseProfile(forEmail:   self.email.value,
                                                  isProfileImage: temp,
                                                  newImage: image)
                if self.userProfileData.value.count == 0 {
                    self.writeProfileLocally(forEmail: self.email.value, isProfileImage: temp, image: image)
                } else {
                    self.updateProfileLocally(forEmail: self.email.value, isProfileImage: temp, image: image)
                }

            }
        }
    }
    
    func convertEmailToName(_ email : String) -> String {
        return email.count > 1 ? email.components(separatedBy: "@")[0] : "Unknown"
    }
    
    func fetchUserNameForCurrentSession() -> String {
        if let userEmail = Auth.auth().currentUser?.email {
            return self.convertEmailToName(userEmail)
        }
        return ""
    }
    
    //MARK: - cloud methods
    
    // fetch the user session email
    func fetchEmail() {
        firebaseService.fetchEmailForCurrentSession()
    }

    // read
    func loadProfileFromFirebase(forEmail email: String) {
        firebaseService.fetchFirebaseData(forEmail: email, category: .profile) { [weak self] in
            guard let self else { return }
            self.realmService.dataExistsInRealm(forEmail: email, queryFilter: "Sender")
        }
    }
    
    // update
    func ModifyFireBaseProfile(forEmail email:String,
                            isProfileImage : Bool,
                            newImage : NSImage ) {
        
        let arg = isProfileImage ? createProfileObject(email: email, profile: newImage)
                                : createProfileObject(email: email, cover: newImage)
        let newImage = NSData(data: convertImageToData(newImage))

        self.firebaseService.modifyFirebaseData(forEmail: email,
                                isProfileImage: isProfileImage,
                                newProfileData : newImage,
                                newProfileDataObject: arg,
                                category: .profile)
    }
    
    //MARK: - local methods
    
    // read
    func loadProfileLocally(forEmail email: String) {
        realmService.dataExistsInRealm(forEmail: email, queryFilter: "Sender")
    }
    
    // write
    func writeProfileLocally(forEmail: String, isProfileImage: Bool, image: NSImage) {
        let arg = isProfileImage ? createProfileObject(email: forEmail, profile: image)
                                : createProfileObject(email: forEmail, cover: image)
        realmService.writeObjectToRealm(arg)
        self.loadProfileLocally(forEmail: forEmail)
    }
    
    //update
    func updateProfileLocally(forEmail: String, isProfileImage: Bool, image: NSImage) {
        let newImage = NSData(data: convertImageToData(image))
        realmService.updateProfileImageInRealm(isProfileImage: isProfileImage,
                            image : newImage)
        self.loadProfileLocally(forEmail: forEmail)
    }
    
    //MARK: - helpers
    private func convertImageToData(_ image: NSImage) -> Data {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return Data() }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        bitmapRep.size = image.size
        return bitmapRep.representation(using: .jpeg, properties: [:]) ?? Data()
    }

    
    private func createProfileObject(email: String, profile: NSImage? = nil, cover: NSImage? = nil) -> Profile {
        let temp = Profile()
        temp.Sender = email
        temp.profile = NSData(data: convertImageToData(profile ?? NSImage()))
        temp.background = NSData(data: convertImageToData(cover ?? NSImage()))
        return temp
    }
}

