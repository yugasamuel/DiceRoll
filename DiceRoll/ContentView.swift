//
//  ContentView.swift
//  DiceRoll
//
//  Created by Yuga Samuel on 11/08/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rollResult = 1
    @State private var totalResult = 1
    @State private var totalSide = 4
    @State private var isCustomizing = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Total: \(totalResult)")
                Spacer()
                Button("Customize") {
                    isCustomizing = true
                }
            }
            .padding()
            
            Text("\(rollResult)")
                .font(.largeTitle)
            
            Button(action: {
                // add action
            }, label: {
                Text("Roll")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .frame(width: 125)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
            })
            .padding(.bottom)
            
            List {
                Text("A")
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
