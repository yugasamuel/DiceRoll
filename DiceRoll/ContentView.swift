//
//  ContentView.swift
//  DiceRoll
//
//  Created by Yuga Samuel on 11/08/23.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var rollResult = 0
    @State private var totalResult = 0
    @State private var totalSide = 4
    @State private var isCustomizing = false
    @State private var isRestarting = false
    @State private var results = [Int]()
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var scaleEffect = 1.0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedData")
    
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
            
            VStack(spacing: 22) {
                Text("Total: \(totalResult)")
                    .font(.headline)
                
                Text("\(rollResult)")
                    .font(.largeTitle)
                    .scaleEffect(scaleEffect)
                
                Button(action: {
                    feedback.notificationOccurred(.success)
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
            Button("4-sided") { updateTotalSide(to: 4) }
            Button("6-sided") { updateTotalSide(to: 6) }
            Button("8-sided") { updateTotalSide(to: 8) }
            Button("10-sided") { updateTotalSide(to: 10) }
            Button("12-sided") { updateTotalSide(to: 12) }
            Button("20-sided") { updateTotalSide(to: 20) }
            Button("100-sided") { updateTotalSide(to: 100) }
            Button("Cancel", role: .cancel) { }
        }
        .alert("Are you sure want to reset?", isPresented: $isRestarting) {
            Button("Reset", role: .destructive) { resetData() }
        }
        .onAppear {
            loadData()
            feedback.prepare()
        }
    }
    
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            let savedData = try JSONDecoder().decode(SavedData.self, from: data)
            results = savedData.results
            rollResult = savedData.rollResult
            totalResult = savedData.totalResult
            totalSide = savedData.totalSide
        } catch {
            results = []
        }
    }
    
    func saveData() {
        let savedData = SavedData(results: results, rollResult: rollResult, totalResult: totalResult, totalSide: totalSide)
        do {
            let data = try JSONEncoder().encode(savedData)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func rollDice() {
        var runCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            rollResult = Array(1...totalSide).randomElement()!
            runCount += 1
            scaleEffect += 0.7
            
            if scaleEffect > 1.7 {
                scaleEffect = 1
            }
            
            if runCount == 16 {
                timer.invalidate()
                results.insert(rollResult, at: 0)
                totalResult += rollResult
                saveData()
            }
        }
    }
    
    func resetData() {
        rollResult = 0
        totalResult = 0
        results.removeAll()
        saveData()
    }
    
    func updateTotalSide(to newTotalSide: Int) {
        totalSide = newTotalSide
        saveData()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
