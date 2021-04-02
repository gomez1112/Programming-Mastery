//
//  CoursesView.swift
//  Programming-Mastery (iOS)
//
//  Created by Gerard Gomez on 3/29/21.
//

import SwiftUI

struct CoursesView: View {
    
    @State private var isDisabled = false
    @State var selectedCourse: Course? = nil
    @State private var show = false
    @Namespace var namespace
    let gridItem: GridItem = GridItem(.adaptive(minimum: 160), spacing: 16)
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [gridItem], spacing: 16) {
                    ForEach(Course.courses) { course in
                        CourseItem(course: course)
                            .matchedGeometryEffect(id: course.id, in: namespace, isSource: !show)
                            .frame(height: 200)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    show.toggle()
                                    selectedCourse = course
                                    isDisabled = true
                                }
                            }
                            .disabled(isDisabled)
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity)
            }
            
            if selectedCourse != nil {
                ScrollView {
                    CourseItem(course: selectedCourse!)
                        .matchedGeometryEffect(id: selectedCourse!.id, in: namespace)
                        .frame(height: 300)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                show.toggle()
                                selectedCourse = nil
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isDisabled = false
                                }
                            }
                        }
                    VStack(spacing: 10) {
                        ForEach(0..<20) { item in
                            CourseRow()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding()
                }
                .background(Color("Background 1"))
                .transition(.asymmetric(
                                insertion: AnyTransition.opacity.animation(Animation.spring().delay(0.3)),
                                removal: AnyTransition.opacity.animation(.spring())))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}



struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoursesView()
        }
    }
}
