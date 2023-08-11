//
//  ContentView.swift
//  DiceRoll
//
//  Created by Yuga Samuel on 11/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rollResult = 1
    @State private var totalResult = 0
    @State private var totalSide = 4
    @State private var isCustomizing = false
    @State private var results = [Int]()
    
    var body: some View {
        VStack {
            HStack {
                Button("Customize") {
                    isCustomizing = true
                }
                Spacer()
                Button("Reset") {
                    totalResult = 0
                }
            }
            .padding()
            
            VStack(spacing: 20) {
                Text("Total: \(totalResult)")
                
                Text("\(rollResult)")
                    .font(.largeTitle)
                
                Button(action: {
                    results.append(rollResult)
                    totalResult += rollResult
                }, label: {
                    Text("Roll")
                        .font(.title2)
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
                Spacer()
                Text("Roll dice to see results of it!")
                Spacer()
            }
        }
        .toolbar {
            
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
