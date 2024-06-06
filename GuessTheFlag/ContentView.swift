//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Samuel Hernandez Vicera on 2/29/24.
//

import SwiftUI

struct flagRendering: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var runningScore = 0
    @State private var roundsPerGame = 0
    @State private var finalRound = false
    
    
    @State private var selectedNumber: Int = -1
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red:0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            
            .ignoresSafeArea()
            VStack{
                
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                VStack(spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                         
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                        ForEach(0..<3) { number in
                            Button {
                                withAnimation { flagTapped(number) }
                            }
                        label: {
                            flagRendering(country: countries[number])
                        }
                        .rotation3DEffect(
                            .degrees(selectedNumber == number  ? 360 : 0), axis: (x: 0.0, y: 1.0, z: 0.0)
                        )
                   
                    
                    }
                
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(runningScore)/\(roundsPerGame)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }
    message: {
            Text("Your score is \(runningScore)")
        }
//    
    .alert(scoreTitle, isPresented: $finalRound){
        Button("Restart", role: .destructive) {
            runningScore = 0
            roundsPerGame = 0
            askQuestion()
        }
        }
    message: {
            Text("Your final score is \(runningScore)/8")
        }
    }
    func flagTapped(_ number: Int){
        roundsPerGame += 1
        selectedNumber = number
        
        if roundsPerGame == 8 {
            if scoreTitle == "Correct" {
                runningScore += 1
            }
            finalAlert()
            return
        }
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            runningScore += 1
           
            
        }        
        else {
            scoreTitle = "Wrong! Thats the flag of \(countries[number])"
       
            
        }
        
        showingScore = true
    
   
    }
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
       
        selectedNumber = -1
    }
    
    func finalAlert(){
        finalRound = true
    }
}

#Preview {
    ContentView()
}
