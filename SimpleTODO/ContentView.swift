//
//  ContentView.swift
//  SimpleTODO
//
//  Created by Mohammad Azam on 8/19/20.
//  Copyright © 2020 Mohammad Azam. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    
    @State private var title: String = ""
    @State private var tasks: [[String: String]] = []
    
    var db = Firestore.firestore()
    
    private func saveTask() {
        
        // save the task to the Firestore database
        db.collection("tasks").addDocument(data: ["title": title]) { error in
            if let error = error {
                print(error)
            } else {
                self.populateTasks()
            }
        }
    }
    
    private func populateTasks() {
        
        db.collection("tasks").getDocuments { (snapshot, error) in
        
            if let snapshot = snapshot {
                
                self.tasks = snapshot.documents.map { doc in
                    return ["title": doc.data()["title"] as! String]
                }
                
            }
            
        }
        
    }
    
    var body: some View {
        VStack {
            TextField("Enter task", text: $title, onEditingChanged: { _ in }, onCommit:{
                self.saveTask()
                }).textFieldStyle(RoundedBorderTextFieldStyle())
           
            List(tasks, id: \.self) { task in
                Text(task["title"] ?? "")
            }
            
            Spacer()
        }.padding()
        
            .onAppear {
                self.populateTasks()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
