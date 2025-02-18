//
//  ContentView.swift
//  MinimalistTodoList
//
//  Created by Joao Leal on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    @State var text: Array<String> = []
    @State var showSheet = false
    @State var textItemTemp = ""
    
    
    var body: some View {
        NavigationStack{
            
            Group{
                if text.count <= 1 {
                    Text("No Item")
                } else {
                    List  {
                        ForEach((1...text.count-1), id: \.self) { i in
                        Text(text[i])
                                .contextMenu {
                                    Button(action: {
                                        text.remove(at: i)
                                    }, label: {
                                        Label("Delete", systemImage: "delete.left")
                                    })
                                }
                        }
                        
                        
                    }
                }
                
            }
            
      
            .navigationTitle("Notes")
            .toolbar {
                Button(action: {
                    showSheet.toggle()
                    textItemTemp = ""
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .onChange(of: text) {
                save()
                load()
            }
            
            .onAppear() {
                save()
                load()
            }
            
            .refreshable {
                save()
                load()
            }
            
            
        }.sheet(isPresented: $showSheet){
            NavigationStack{
            
                    List{
                        TextField("item", text: $textItemTemp)
                    }
                    .navigationTitle("Add Item")
                    .toolbar {
                        Button("Add"){
                            text.append(textItemTemp)
                            showSheet.toggle()
                        }
                    }
                
            }
        }
    }
    func save() -> Void {
        let temp = text.joined(separator: "/[split]/")
        let key = UserDefaults.standard
        key.set(temp, forKey: "text")
    }
    
    func load() -> Void {
        let key = UserDefaults.standard
        let temp = key.string(forKey: "text") ?? ""
        let temparray = temp.components(separatedBy: "/[split]/")
        text = temparray
    }
}

#Preview {
    ContentView()
}
