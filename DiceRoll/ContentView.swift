//
//  ContentView.swift
//  DiceRoll
//
//  Created by Yuga Samuel on 11/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rollResult = 0
    @State private var totalResult = 0
    @State private var totalSide = 4
    @State private var isCustomizing = false
    @State private var isRestarting = false
    @State private var results = [Int]()
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedResults")
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isRestarting = true
                }, label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                })
                
                Spacer()
                
                Button(action: {
                    isCustomizing = true
                }, label: {
                    Label("\(totalSide)-sided", systemImage: "dice")
                })
            }
            .padding()
            
            VStack(spacing: 20) {
                Text("Total: \(totalResult)")
                    .font(.headline)
                
                Text("\(rollResult)")
                    .font(.largeTitle)
                
                Button(action: {
                    rollDice()
                }, label: {
                    Text("Roll")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(width: 125)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                })
            }
            .padding(.bottom, 25)
            
            if !results.isEmpty {
                List {
                    ForEach(results, id: \.self) { result in
                        Text("\(result)")
                    }
                }
            } else {
                VStack {
                    Spacer()
                    Text("It's time to roll the dice!")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6))
            }
        }
        .confirmationDialog("Customize", isPresented: $isCustomizing) {
            Button("4-sided") { totalSide = 4 }
            Button("6-sided") { totalSide = 6 }
            Button("8-sided") { totalSide = 8 }
            Button("10-sided") { totalSide = 10 }
            Button("12-sided") { totalSide = 12 }
            Button("20-sided") { totalSide = 20 }
            Button("100-sided") { totalSide = 100 }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Reset confirmation", isPresented: $isRestarting) {
            Button("Confirm", role: .destructive) { resetData() }
        }
        .onAppear {
            loadData()
        }
    }

    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            results = try JSONDecoder().decode([Int].self, from: data)
            for result in results {
                totalResult += result
            }
        } catch {
            results = []
        }
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(results)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func resetData() {
        totalResult = 0
        results.removeAll()
        saveData()
    }
    
    func rollDice() {
        rollResult = Array(1...totalSide).randomElement()!
        results.append(rollResult)
        totalResult += rollResult
        saveData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
