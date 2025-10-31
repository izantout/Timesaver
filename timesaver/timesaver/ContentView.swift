import SwiftUI
#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

struct ContentView: View {
    // MARK: This app was done by Issam Zantout. issamzantout18@gmail.com

    
    // MARK: Variables
    
    // Showcase
    @State private var showcaseResult = "Pass"
    @State private var showcaseComment = ""
    let showcaseOptions = ["Pass", "Fail"]
    
    // CI
    @State private var CICategory = "NTF"
    @State private var CIComment = ""
    let CICategoryOptions = ["NTF", "STF", "DTF"]
    
    // TF
    @State private var TFResult = "CND"
    @State private var TFComment = ""
    let TFResultOptions = ["CND", "DTF", "STF"]
    
    // Template Builder
    var template: String {
        """
        Showcase Result: \(showcaseResult)
        Showcase Comments: \(showcaseComment)
        CI Category: \(CICategory)
        CI Comments: \(CIComment)
        TF Result: \(TFResult)
        TF Comments: \(TFComment)
        """
    }
    
    // Copy
    @State private var showCopiedAlert = false
    
    // Email
    @State private var email = ""
    @State private var showEmailAlert = false
    @State private var sentToEmail = ""
        
    var body: some View {
        ScrollView{
            VStack(spacing: 25) {
                Text("Results Form")
                    .font(.title)
                    .fontWeight(.bold)
                
                // MARK: Showcase Result
                VStack(alignment: .leading, spacing: 10) {
                    Text("Showcase Result")
                        .font(.headline)
                    Picker("Showcase Result", selection: $showcaseResult) {
                        ForEach(showcaseOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    TextField("Comments", text: $showcaseComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                
                // MARK: CI
                VStack(alignment: .leading, spacing: 10) {
                    Text("CI Category")
                        .font(.headline)
                    Picker("CI Category", selection: $CICategory) {
                        ForEach(CICategoryOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    TextField("Comments", text: $CIComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // MARK: TF
                VStack(alignment: .leading, spacing: 10) {
                    Text("TF Result")
                        .font(.headline)
                    Picker("TF Result", selection: $TFResult) {
                        ForEach(TFResultOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    TextField("Comments", text: $TFComment)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Divider().padding(.vertical, 10)
                
                // MARK: Template Look
                Text("Template Look")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Showcase Result: \(showcaseResult)")
                    Text("Details: \(showcaseComment)")
                    Text("CI: \(CICategory)")
                    Text("Details: \(CIComment)")
                    Text("TF: \(TFResult)")
                    Text("Details: \(TFComment)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(8)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // MARK: Copy & Send Email
                HStack(spacing: 12) {
                    
                    
                    // MARK: Copy
                    Button(action: {
                        copyToClipboard()
                        resetForm()
                    }) {
                        Text("Copy")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .alert("Copied to clipboard!", isPresented: $showCopiedAlert) {
                        Button("OK", role: .cancel) { }
                    }

                    // MARK: Send Email
                    Button(action: {
                        sendToEmail(
                            emailAddress: email,
                            subject: "Results Summary",
                            body: template
                        )
                        sentToEmail = email
                        showEmailAlert = true
                        resetForm()
                    }) {
                        Text("Send to Email")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .alert("Email sent to: \(sentToEmail)", isPresented: $showEmailAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)


                
                Spacer()
            }
            
            .padding()
        }
    }

    // MARK: Copy Function
    func copyToClipboard() {
    #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(template, forType: .string)
    #elseif os(iOS)
        UIPasteboard.general.string = template
    #endif
        showCopiedAlert = true
    }
    
    // MARK: Send Email Function
    func sendToEmail(emailAddress: String, subject: String = "Results Summary", body: String = "") {
        // Encode the subject and body to be URL-safe
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Create the mailto URL
        let mailtoString = "mailto:\(emailAddress)?subject=\(encodedSubject)&body=\(encodedBody)"
        
        if let mailtoURL = URL(string: mailtoString) {
            // Open the Mail app
            #if os(macOS)
                if let mailtoURL = URL(string: mailtoString) {
                    NSWorkspace.shared.open(mailtoURL)
                }
            #elseif os(iOS)
                if let mailtoURL = URL(string: mailtoString) {
                    UIApplication.shared.open(mailtoURL)
                }
            #endif
        } else {
            print("Failed to create mailto URL.")
        }
    }
    
    // MARK: Reset form Function
    func resetForm() {
        showcaseResult = "Pass"
        showcaseComment = ""
        CICategory = "NTF"
        CIComment = ""
        TFResult = "CND"
        TFComment = ""
        email = ""
    }

}

#Preview {
    ContentView()
}
