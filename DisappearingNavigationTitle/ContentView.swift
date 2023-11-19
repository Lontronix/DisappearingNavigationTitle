//
//  ContentView.swift
//  SafeAreaFun
//
//  Created by Lonnie Gerol on 11/18/23.
//

import SwiftUI

struct ContentView: View {

    @State private var frame: CGRect?
    @State private var size: CGSize?
    @State private var safeAreaInsets: EdgeInsets?

    @State private var importantCellIsHidden = false

    var showTitle: Bool {
        guard let frame else { return false }
        return (
            frame.intersects(safeAreaRect) ||
            importantCellIsHidden ||
            frame.minY < safeAreaRect.minY
        )
    }

    var safeAreaRect: CGRect {
        CGRect(
            x: 0,
            y: 0,
            width: size?.width ?? 0,
            height: safeAreaInsets?.top ?? 0
        )
    }

    var intersectionRatio: CGFloat {
        guard let frame else { return 1.0 }
        guard frame.minY > safeAreaRect.minY else {
            return 1
        }
        let intersectionHeight = frame.intersection(safeAreaRect).height
        return (intersectionHeight) / (frame.height)
    }


    var body: some View {
        NavigationStack {
            GeometryReader { reader in
                List {
                    Section {
                        Text("Hello World")
                            .onDisappear {
                                importantCellIsHidden = true
                            }
                            .onAppear {
                                importantCellIsHidden = false
                            }
                            .background {
                                GeometryReader { innerReader in
                                    Color.clear
                                        .onChange(of: innerReader.frame(in: .global)) { newFrame, oldFrame in
                                            self.frame = newFrame
                                        }
                                }
                            }
                    }
                    ForEach(0..<100) { index in
                        Text("\(index)")
                    }
                }
                .onAppear {
                    self.size = reader.size
                    self.safeAreaInsets = reader.safeAreaInsets
                }
                .onChange(of: reader.size) {
                    size = reader.size
                }
                .onChange(of: reader.safeAreaInsets) {
                    safeAreaInsets = reader.safeAreaInsets
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if showTitle {
                        Text("Hello World").opacity(intersectionRatio)
                            .fontWeight(.medium)
                    } else {
                        Text("Hello World").opacity(0)
                            .fontWeight(.medium)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
