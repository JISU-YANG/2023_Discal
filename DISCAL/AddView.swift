//
//  AddView.swift
//  DISCAL
//
//  Created by JISU YANG on 2023/02/17.
//

import SwiftUI

struct Item: Identifiable{
    var id: Int
    var price: String
    var checked: Bool
}

struct AddView: View {
    @State var items: [Item] = []
    @State var result: String = "0"
    @State var cnt = 0
    init() {
          //Use this if NavigationBarTitle is with Large Font
          UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

          //Use this if NavigationBarTitle is with displayMode = .inline
          UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
      }

    
    var body: some View {
       
            NavigationView {
                ZStack{
                Color(.black).ignoresSafeArea()
                VStack(alignment: .leading){
                    HStack{
                        Text("선택")
                            .padding()
                        Spacer()
                        Text("정상금액")
                            .padding()
                        Spacer()
                        Text("할인적용")
                            .padding()

                    }
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    HStack {
                        List {
                          ForEach(items, id: \.id) { item in
                              HStack{
                                  Image(systemName: items[item.id].checked ? "checkmark.square.fill" : "square")
                                        .foregroundColor(items[item.id].checked ? Color(UIColor.systemBlue) : Color.secondary)
                                        .onTapGesture {
                                            items[item.id].checked.toggle()
                                        }
                                        
                                  Spacer()
                                  Text(String(item.price))
                                  Spacer()
                                  Text(String(getDiscount(price: Int(item.price)!)))
                              }
                             
                          }
                        }
                        .background(.black)
                        .scrollContentBackground(.hidden)
                    }
                    HStack{
                        VStack(alignment: .trailing){
                            Text(result)
                                .font(.title)
                                .foregroundColor(.white)

                        }.padding()
                            .frame(maxWidth:.infinity)
                            .background(.black)
                            .cornerRadius(4)
                    }
                    HStack{
                        VStack{
                            KeyPadLine(first: "1", second: "2", third: "3", result: $result)
                            KeyPadLine(first: "4", second: "5", third: "6", result: $result)
                            KeyPadLine(first: "7", second: "8", third: "9", result: $result)
                            KeyPadLine(first: "0", second: "00", third: "←", result: $result)
                        }
                        .padding()
                        .background(.black)
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        Button {
                            items = []
                            result = "0"
                            cnt = 0
                        } label: {
                            Text("처음부터")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Spacer()
                        
                        Button {
                            var text = "[   올리브영   ] 임직원 할인 영수증\n"
                            text += "------------------------------\n"
                            text += "NO\(makeTab())판매금액\(makeTab())할인금액\n"
                            text += "------------------------------\n"

                            var sum = 0
                            var sumBefore = 0
                            var count = 0
                            for item in items {
                                if item.checked {
                                    let itemPrice = String(getDiscount(price: Int(item.price)!))
                                    let no = count + 1 > 10 ? String(count + 1) : "0" + String(count + 1)
                                    text += "\(no + makeTab())"
                                    text += "\(makeFiveDigits(num: item.price))원\(makeTab())"
                                    text += "\(makeFiveDigits(num: itemPrice))원\(makeTab())\n"
                                    
                                    sum += Int(itemPrice)!
                                    sumBefore += Int(item.price)!
                                    count += 1
                                }
                            }
                            text += "------------------------------\n"
                          
                            text += "\(count)개" + makeTab() +
                            makeFiveDigits(num: String(sumBefore)) + "원" + makeTab() +
                            makeFiveDigits(num: String(sum)) + "원\n"
                            text += "------------------------------"
                            UIPasteboard.general.string = text

                        } label: {
                            Text("선택 항목 복사하기")
                                .foregroundColor(.white)
                                .font(.headline)                        }
                        Spacer()
                        
                        Button {
                            let tempItem = Item(id: cnt, price: result, checked: false)
                            items.append(tempItem)
                            result = "0"
                            cnt+=1
                        } label: {
                            Text("추가하기")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Spacer()

                    }

                }.navigationBarTitle(Text("올리브영 임직원 할인 계산기"), displayMode: NavigationBarItem.TitleDisplayMode.inline)
                    
            }
        }
    }
    func makeTab() -> String{
        return "          "
    }
    func makeFiveDigits(num: String) -> String{
        return Int(num)! > 9999 ? num : "  \(num)"
    }
    func getDiscount(price: Int) -> Int{
        let discountPrice = Int(Double(price) * 0.6)
        let discountCeilPrice = Int(discountPrice / 100) * 100
        return (discountPrice % 100 > 0) ?  discountCeilPrice : discountCeilPrice + 100
    }
    
    struct KeyPad: View {
        @Binding var result: String
        
        var number: String
        var body: some View {
        
            Button {
                if number == "←" {
                    result = String(result[result.startIndex..<result.index(result.endIndex, offsetBy: -1)])
                    if result == "" {
                        result = "0"
                    }
                }else{
                    if result == "0" {
                        result = number == "00" ? "0" : number
                    } else{
                        result += number
                    }
                }
                
               
            } label: {
                Text(String(number))
                    .padding()
                    .frame(maxWidth:.infinity)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(4)
                
            }
        }
    }

    struct KeyPadLine: View {
        var first: String
        var second: String
        var third: String
        @Binding var result: String
        
        var body: some View{
            HStack{
                Spacer()
                KeyPad(result: $result, number: first)
                Spacer()
                KeyPad(result: $result, number: second)
                Spacer()
                KeyPad(result: $result, number: third)
                Spacer()

            }
        }
    }

}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}


