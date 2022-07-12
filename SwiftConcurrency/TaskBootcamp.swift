//
//  TaskBootcamp.swift
//  SwiftConcurrency
//
//  Created by Kim Jongwon on 2022/07/12.
//

import SwiftUI

@MainActor
class TaskBootcampVM: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        
//        for x in array {
//
//            try Task.checkCancellation()
//        }
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run(body: {
                self.image = UIImage(data: data)
                print("**** Image returned successful")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image2 = UIImage(data: data)
            print("**** Image returned successful")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("Click me") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var vm = TaskBootcampVM()
    @State private var fetchImagetask: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onDisappear {
            fetchImagetask?.cancel()
        }
        .onAppear {
            fetchImagetask = Task {
                print(Thread.current)
                print(Task.currentPriority)
                await vm.fetchImage()
//                await vm.fetchImage2()
            }
//            fetchImagetask = Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await vm.fetchImage2()
//            }
        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
