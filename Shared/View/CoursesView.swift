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
            
            #if os(iOS)
            content
                .navigationBarHidden(true)
            fullContent
                .background(VisualEffectBlur(blurStyle: .systemMaterial).edgesIgnoringSafeArea(.all))
            #else
            content
            fullContent
                .background(VisualEffectBlur().edgesIgnoringSafeArea(.all))
            #endif
        }
        .navigationTitle("Courses")
    }
    var content: some View {
        ScrollView {
            LazyVGrid(columns: [gridItem], spacing: 16) {
                ForEach(Course.courses) { course in
                    VStack {
                        CourseItem(course: course)
                            .matchedGeometryEffect(id: course.id, in: namespace, isSource: !show)
                            .frame(height: 200)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0)) {
                                    show.toggle()
                                    selectedCourse = course
                                    isDisabled = true
                                }
                            }
                            .disabled(isDisabled)
                    }
                    .matchedGeometryEffect(id: "container\(course.id)", in: namespace, isSource: !show)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
        }
        .zIndex(1)
    }
    @ViewBuilder
    var fullContent: some View {
        if selectedCourse != nil {
            ZStack(alignment: .topTrailing) {
                CourseDetail(course: selectedCourse!, namespace: namespace)
                
                CloseButton()
                    .padding(16)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            show.toggle()
                            selectedCourse = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isDisabled = false
                            }
                        }
                    }
                
            }
            .zIndex(2)
            .frame(maxWidth: 712)
            .frame(maxWidth: .infinity)
        }
    }
}



struct CoursesView_Previews: PreviewProvider {
    static var previews: some View {
            CoursesView()
    }
}
