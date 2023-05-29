//
//  TDTaskViewModel.swift
//  ToDo
//
//  Created by Apple Macbook on 28/05/2023.
//

import AppKit
import Firebase
import RealmSwift

class TDTaskViewModel: BaseViewModel , UserAccountDataManagementProtocol {
    
    typealias T = Task
    private let db = Firestore.firestore()
    
    lazy var taskList : Binder = Binder< Results<Task> >(realm.objects(Task.self))
    
    private let realmService = RealmManager<Task>()
    private let firebaseService = FirebaseManager<Task>()
    
    var email = Binder<String>("")
    var error = Binder<String>("")
    
    override init() {
        super.init()
        
        realmService.error.bind {[weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        realmService.fetchedObjects.bind { [weak self]  updatedObjects in
            guard let self else {return}
            self.taskList.value = updatedObjects
        }
        firebaseService.error.bind { [weak self] comingErr in
            guard let self else { return }
            self.error.value = comingErr
        }
        firebaseService.email.bind { [weak self] userEmail in
            guard let self else {return }
            self.email.value = userEmail
        }
    }
    
    
    //MARK: - cloud functions
    
    // fetching email
    func fetchEmail() {
        firebaseService.fetchEmailForCurrentSession()
    }
    
    // load
    func fetchDataFromFirebase(forEmail email: String ){
        firebaseService.fetchFirebaseData(forEmail: email, category: .taskList) {[weak self] in
            guard let self else { return }
            self.realmService.dataExistsInRealm(forEmail: email, queryFilter: "TaskSender")
        }
    }
    
    // upload
    func uploadDataToFirebase(forEmail email: String,
                              Obj comingObj: Task){
        firebaseService.uploadFirebaseData(forEmail: email, object: comingObj, category: .taskList)
    }
    
    // modify
    func ModifyFireBaseData(forEmail email:String,
                            forTitle comingTitle : String,
                            newTitle: String? = nil,
                            newCheck: Bool? = nil,
                            toDel: Bool = false) {
        firebaseService.modifyFirebaseData(forEmail: email, currentTitle: comingTitle, newTitle: newTitle, newCheckValue: newCheck, delete: toDel, category: .taskList)
    }
    
    //MARK: - local functions
    
    //write
    
    func writeObjectLocally(_ comingObj : Task) {
        realmService.writeObjectToRealm(comingObj)
        self.fetchObjectsLocally(forEmail: comingObj.TaskSender)
    }
    
    //load
    func fetchObjectsLocally(forEmail email: String){
        realmService.dataExistsInRealm(forEmail: email, queryFilter: "TaskSender")
    }
    
    // update
    func updateObjectLocally(atIndex index: Int, title: String) {
        realmService.updateCategoryTitleInRealm(title: title, at: index, category: .taskList)
    }
    
    // delete
    func deleteObjectLocally(atIndex index: Int){
        realmService.deleteObjectFromRealm(atIndex: index)
    }
}
