//
//  TaskEditView.swift
//  ToDoList App
//
//  Created by Kalyanasundaram, Dhivya (Cognizant) on 06/03/25.
//

import SwiftUI
import MapKit

struct TaskEditView: View {
    
    @State private var selectedPriority: Priority = .low
    @State private var selectedCategory: Category = .personal
    @State var selectedTask: Item?
    @State var taskTitle: String
    @State var taskDescription: String
    @State var scheduleTime: Bool
    @State var dueDate: Date
    
    @State private var location: String = ""
    @State private var showingMap = false
    @State private var selectedCoordinate: IdentifiableCoordinate?
    
    @State private var selectedDate = Date()
    @State private var showDatePicker = false
    
    init(passedTask: Item? = nil, initialDate: Date) {
        if let selectedTask = passedTask {
            _selectedTask = State(initialValue: selectedTask)
            _taskTitle = State(initialValue: "selectedTask.timestamp" ?? "")
            _taskDescription = State(initialValue: "selectedTask.timestamp" ?? "")
            _dueDate = State(initialValue: selectedTask.timestamp ?? initialDate)
            _scheduleTime = State(initialValue: (selectedTask.timestamp != nil))
        }
        else {
            _taskTitle = State(initialValue: "")
            _taskDescription = State(initialValue: "")
            _dueDate = State(initialValue: initialDate )
            _scheduleTime = State(initialValue: false)
            
        }
    }
    var body: some View {
        Form {
            Section(header: Text("Task")) {
                TextField("Task Title", text: $taskTitle)
                TextField("Task Description", text: $taskDescription)
            }
            
            Section(header: Text("Task Due")) {
                // Toggle("Schedule Time", isOn: $scheduleTime)
                DatePicker("Schedule Time", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                //                DatePicker("Due Date", selection: $dueDate, displayedComponents: displayComponents())
            }
            
            Section(header: Text("Priority")){
                
                Picker("Select Priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                    
                }
                .pickerStyle(MenuPickerStyle())
            }
            Section(header: Text("Category")){
                
                Picker("Select Category", selection: $selectedCategory) {
                    ForEach(Category.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section(header: Text("Location")) {
                HStack{
                    
                    TextField("Enter location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .multilineTextAlignment(.center)
                    // .padding()
                    Spacer()
                    Button(action: {
                        showingMap = true
                    }) {
                        Text("Select from Map")
                            .padding(10)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $showingMap) {
                        MapView(selectedCoordinate: $selectedCoordinate, location: $location)
                    }
                }
            }
//            
//            
//            Button("Save", action: {
//                print("button presses")
//            })
            
        }
        Spacer()
        Button("Save", action: {
            print("button presses")
        }).padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .frame(height: 60)
            .cornerRadius(15)
        
        
       
    }
    func displayComponents() {
        
    }
    
    func saveAction() {
        
    }
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
}

enum Priority: String, CaseIterable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

enum Category : String, CaseIterable {
    case personal = "Personal"
    case office = "Office"
    case shopping = "Shopping"
    case others = "Others"
}
struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCoordinate: IdentifiableCoordinate?
    @Binding var location: String
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: [selectedCoordinate].compactMap { $0 }) { item in
                MapPin(coordinate: item.coordinate)
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                let location = region.center
                selectedCoordinate = IdentifiableCoordinate(coordinate: location)
                getLocationName(from: location) { name in
                    self.location = name ?? "\(location.latitude), \(location.longitude)"
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
    
    func getLocationName(from coordinate: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                completion(placemark.name)
            } else {
                completion(nil)
            }
        }
    }
}
#Preview {
    TaskEditView(initialDate: Date.now)
}
