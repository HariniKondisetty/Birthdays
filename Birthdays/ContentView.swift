//
//  ContentView.swift
//  Birthdays
//
//  Created by Scholar on 7/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var friends: [Friend]
    @State private var newName = ""
    @State private var newBirthday = Date.now
    
    var body: some View
    {
        NavigationStack
        {
            List {
                ForEach(friends){ friend in
                    HStack
                    {
                        Text(friend.name)
                        Spacer()
                        Text(friend.birthday, format:.dateTime.month(.wide).day().year())
                            .toolbar{
                                EditButton()
                            }
                    }
                }
                .onDelete(perform: deleteFriend)
            }
            .navigationTitle("Bday reminder app")
            .safeAreaInset(edge: .bottom)
            {
                VStack(alignment: .center, spacing: 20)
                {
                    Text("New Birthday").font(.headline)
                    DatePicker(selection: $newBirthday, in: Date.distantPast...Date.now, displayedComponents: .date)
                    {
                        TextField("Name", text:$newName).textFieldStyle(.roundedBorder)
                    }
                    Button("SAVE!!")
                    {
                        let newFriend = Friend(name: newName, birthday: newBirthday)
                            newName = ""
                            newBirthday = .now
                        modelContext.insert(newFriend)
                    }
                    .padding()
                    .background(.bar)
                }
                
            }
        }
    }
    private func deleteFriend(at offsets: IndexSet) {
        for index in offsets {
            let friendToDelete = friends[index]
            modelContext.delete(friendToDelete)
        }
    }
}
    
    #Preview {
        ContentView()
            .modelContainer(for: Friend.self, inMemory: true)
    }

