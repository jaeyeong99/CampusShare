//
//  RentalListRow.swift
//  GnuRental
//
//  Created by 정재영 on 2/1/24.
//

import SwiftUI

struct RentalListRow: View {
    let backGroundColor = Color(red: 37/255, green: 38/255, blue: 38/255, opacity: 1)
    
    var rentalItem: RentalItem
    
    var body: some View {

        VStack{
            Image("ListRowBackground")
                .resizable()
                .scaledToFit()
                .overlay(
                    
                    HStack{
                        Image(rentalItem.image)
                            .resizable()
                            .frame(width: 54.4, height: 54.4)
                        
                        VStack(alignment: .leading){
                            
                            Text(rentalItem.title)
                                .font(.system(size: 20))
                            
                            Text("잔여 수량 : " + String(rentalItem.count))
                                .font(.system(size: 15))
                        }
                        .padding(.leading, 10)
                        
                        
                        Spacer()
                        
                        NavigationLink(destination: RentalDetailView()) {
                            
                            Image("ListRowButton")
                                .resizable()
                                .frame(width: 90, height: 43)
                                .overlay(
                                    Text("예약하기")
                                        .foregroundColor(.white)
                                        .font(.system(size: 15))
                                )
                            
                        }
                    }
                        .listRowBackground(backGroundColor)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                )
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

#Preview {
    RentalListRow(rentalItem: rentalItems[0])
}
