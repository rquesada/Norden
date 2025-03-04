//
//  LoginView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        ZStack {
            Color("primaryColor")
                .edgesIgnoringSafeArea(.all)
            
            //Panel
            VStack {
                Spacer()
                
                VStack{
                    // Header
                    VStack{
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                        Text("Welcome to Mind’s Norden")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("primaryColor"))
                            .padding(.top, 5)
                        
                        Text("By Mind Group")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Main
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("Use your Mind email", text: $viewModel.username)
                            .padding(1)
                            .background(Color.white)
                            .cornerRadius(8)
                            .autocapitalization(.none)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                        
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SecureField("Type your password", text: $viewModel.password)
                            .padding(1)
                            .background(Color.white)
                            .cornerRadius(8)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.leading)
                        
                        Text("Forgot your password?")
                            .foregroundColor(Color("secondaryColor"))
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                // Acción para recuperar contraseña
                            }
                        
                        // Botón Log in centrado
                        Button(action: {
                            viewModel.login()
                        }) {
                            Text(viewModel.isLoading ? "Loading..." : "Log in")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("secondaryColor"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .fontWeight(.bold)
                        }
                        .disabled(viewModel.isLoading)
                    }
                    .padding()
                }
                .background(.white)
                .cornerRadius(8)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                
                
                Spacer()
                
                // Footer
                VStack {
                    
                    HStack{
                        Text("Powered by Norden")
                            .foregroundColor(.white)
                            .font(.caption)
                        Text("©Mind Group 2025")
                            .foregroundColor(Color("secondaryColor"))
                            .font(.caption)
                    }
                    
                    
                    
                    HStack {
                        Image("arkus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        
                        Image("michelada")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
