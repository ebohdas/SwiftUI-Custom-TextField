//
//  EGTextField.swift
//  EGTextField
//
//  Created by Esat Gözcü on 2023/03/30.
//

import SwiftUI

@available(iOS 13.0, *)
public struct EGTextField: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var trailingImage : Image?
    @State private var secureText = false{
        didSet{
            if secureText{
                isFocused = false
            }
        }
    }
    @State var isFocused = false
    private var lineLimit: Int?
    private var text: Binding<String>
    private var disable: Binding<Bool>?
    private var error: Binding<Bool>?
    private var errorText: Binding<String>?
    private var isSecureText: Bool = false
    private var titleText: String?
    private var placeHolderText: String = ""
    private var trailingImageClick: (() -> Void)?
    private var secureFocusLostAction: (() -> Void)?
    private var secureTextImageOpen : Image? = Image(systemName: "eye.fill")
    private var secureTextImageClose : Image? = Image(systemName: "eye.slash.fill")
    private var maxCount: Int?
    private var truncationMode: Text.TruncationMode = Text.TruncationMode.tail
    //Text Color
    private var defaultTextColor = EGTextFieldConfig.shared.defaultTextColor
    private var darkModeTextColor = EGTextFieldConfig.shared.darkModeTextColor
    //Title Color
    private var defaultTitleColor = EGTextFieldConfig.shared.defaultTitleColor
    private var darkModeTitleColor = EGTextFieldConfig.shared.darkModeTitleColor
    //PlaceHolder Text Color
    private var defaultPlaceHolderTextColor = EGTextFieldConfig.shared.defaultPlaceHolderTextColor
    private var darkModePlaceHolderTextColor = EGTextFieldConfig.shared.darkModePlaceHolderTextColor
    //Disable Color
    private var defaultDisableColor = EGTextFieldConfig.shared.defaultDisableColor
    private var darkModeDisableColor = EGTextFieldConfig.shared.darkModeDisableColor
    //Background Color
    private var defaultBackgroundColor = EGTextFieldConfig.shared.defaultBackgroundColor
    private var darkModeBackgroundColor = EGTextFieldConfig.shared.darkModeBackgroundColor
    //Error Text Color
    private var defaultErrorTextColor = EGTextFieldConfig.shared.defaultErrorTextColor
    private var darkModeErrorTextColor = EGTextFieldConfig.shared.darkModeErrorTextColor
    //Border Color
    private var defaultBorderColor = EGTextFieldConfig.shared.defaultBorderColor
    private var darkModeBorderColor = EGTextFieldConfig.shared.darkModeBorderColor
    //Trailing Image Color
    private var defaultTrailingImageForegroundColor = EGTextFieldConfig.shared.defaultTrailingImageForegroundColor
    private var darkModeTrailingImageForegroundColor = EGTextFieldConfig.shared.darkModeTrailingImageForegroundColor
    //Focused Border Color
    private var focusedBorderColorEnable = EGTextFieldConfig.shared.focusedBorderColorEnable
    private var defaultFocusedBorderColor = EGTextFieldConfig.shared.defaultFocusedBorderColor
    private var darkModeFocusedBorderColor = EGTextFieldConfig.shared.darkModeFocusedBorderColor
    //Font
    private var titleFont = EGTextFieldConfig.shared.titleFont
    private var textFont = EGTextFieldConfig.shared.textFont
    private var errorFont = EGTextFieldConfig.shared.errorFont
    private var placeHolderFont = EGTextFieldConfig.shared.placeHolderFont
    //Default
    private var borderWidth = EGTextFieldConfig.shared.borderWidth
    private var cornerRadius = EGTextFieldConfig.shared.cornerRadius
    private var borderType = EGTextFieldConfig.shared.borderType
    private var disableAutoCorrection = EGTextFieldConfig.shared.disableAutoCorrection
    private var textFieldHeight = EGTextFieldConfig.shared.textFieldHeight
    private var textContentType = EGTextFieldConfig.shared.textContentType

    public init(text: Binding<String>) {
        self.text = text
    }
    
    public var body: some View{
        VStack(spacing: 8){
            //Title
            if let titleText{
                Text(titleText)
                    .font(titleFont)
                    .foregroundColor(getTitleTextColor())
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(spacing: 0){
                //TextField
                HStack(spacing: 0){
                    secureAnyView()
                        .placeholder(when: text.wrappedValue.isEmpty, placeholder: {
                            Text(placeHolderText)
                                .foregroundColor(getPlaceHolderTextColor())
                                .font(placeHolderFont)
                        })
                        .frame(maxWidth: .infinity)
                        .frame(height: textFieldHeight)
                        .foregroundColor(getTextColor())
                        .disabled(disable?.wrappedValue ?? false)
                        .padding([.leading, .trailing], borderType == .square ? 12 : 1)
                        .disableAutocorrection(disableAutoCorrection)
                        .onReceive(text.wrappedValue.publisher.collect()) {
                            if let maxCount{
                                let s = String($0.prefix(maxCount))
                                if text.wrappedValue != s && (maxCount != 0){
                                    text.wrappedValue = s
                                }
                            }
                        }
                        .truncationMode(truncationMode)
                        .background(Color.clear)
                    trailingImage?
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(getTrailingImageForegroundColor())
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 12)
                        .onTapGesture {
                            if isSecureText {
                                let wasFocused = self.isFocused
                                secureText.toggle()
                                trailingImage = secureText ? secureTextImageClose : secureTextImageOpen
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    if wasFocused {
                                        self.isFocused = wasFocused
                                        secureFocusLostAction?()
                                    }
                                })
                            } else {
                                trailingImageClick?()
                            }
                        }
                        .disabled(disable?.wrappedValue ?? false)
                }.background(
                    RoundedRectangle(cornerRadius: getCornerRadius())
                        .stroke(getBorderColor(), lineWidth: getBorderWidth(type: .square))
                        .background(getBackgroundColor().cornerRadius(getCornerRadius()))
                )
                //Bottom Line
                if borderType == .line{
                    Rectangle()
                        .frame(height: getBorderWidth(type: .line))
                        .foregroundColor(getBorderColor())
                }
            }
            //Bottom text
            if let error = error?.wrappedValue, let errorText = errorText?.wrappedValue {
                if error {
                    Text(errorText)
                        .font(errorFont)
                        .foregroundColor(getErrorTextColor())
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    private func secureAnyView() -> AnyView{
        if !secureText{
            if let lineLimit = self.lineLimit {
                if #available(iOS 16.0, *) {
                    return AnyView(TextField("", text: text, axis: .vertical)
                        .font(textFont)
                        .textContentType(textContentType)
                        .lineLimit(lineLimit, reservesSpace: true)
                        .onTapGesture {
                            isFocused = true
                        })
                } else {
                    return AnyView(TextField("", text: text, onEditingChanged: { changed in
                        if changed{
                            isFocused = true
                        }
                        else{
                            isFocused = false
                        }
                    })
                    .font(textFont)
                    .textContentType(textContentType))
                }
            } else {
                return AnyView(TextField("", text: text, onEditingChanged: { changed in
                    if changed{
                        isFocused = true
                    }
                    else{
                        isFocused = false
                    }
                })
                .font(textFont)
                .textContentType(textContentType))
            }
        }
        else{
            return AnyView(
                SecureField("", text: text, onCommit: { isFocused = false })
                    .font(textFont)
                    .textContentType(textContentType)
                    .onTapGesture {
                        isFocused = true
                    })
        }
    }
    private func getBorderColor() -> Color{
        if error?.wrappedValue ?? false {
            return getErrorTextColor()
        }
        else{
            if colorScheme == .light{
                if isFocused && focusedBorderColorEnable{
                    return defaultFocusedBorderColor
                }
                else{
                    return defaultBorderColor
                }
            }
            else{
                if isFocused && focusedBorderColorEnable{
                    return darkModeFocusedBorderColor
                }
                else{
                    return darkModeBorderColor
                }
            }
        }
    }
    private func getBackgroundColor() -> Color{
        if disable?.wrappedValue ?? false{
            return colorScheme == .light ? defaultDisableColor : darkModeDisableColor
        }
        else{
            return colorScheme == .light ? defaultBackgroundColor : darkModeBackgroundColor
        }
    }
    private func getTextColor() -> Color{
        return colorScheme == .light ? defaultTextColor : darkModeTextColor
    }
    private func getErrorTextColor() -> Color{
        return colorScheme == .light ? defaultErrorTextColor : darkModeErrorTextColor
    }
    private func getPlaceHolderTextColor() -> Color{
        return colorScheme == .light ? defaultPlaceHolderTextColor : darkModePlaceHolderTextColor
    }
    private func getTitleTextColor() -> Color{
        return colorScheme == .light ? defaultTitleColor : darkModeTitleColor
    }
    private func getBorderWidth(type: BorderType) -> CGFloat{
        if type == .square{
            return borderType == .square ? borderWidth : 0.0
        }
        else{
            return borderWidth
        }
    }
    private func getCornerRadius() -> CGFloat{
        return borderType == .square ? cornerRadius : 0.0
    }
    private func getTrailingImageForegroundColor() -> Color{
        return colorScheme == .light ? defaultTrailingImageForegroundColor : darkModeTrailingImageForegroundColor
    }
}

@available(iOS 13.0, *)
extension EGTextField{
    public func setTextColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultTextColor = color
        return copy
    }
    public func setTextFont(_ font: Font) -> Self{
        var copy = self
        copy.textFont = font
        return copy
    }
    public func setDarkModeTextColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeTextColor = color
        return copy
    }
    public func setTitleText(_ titleText: String) -> Self{
        var copy = self
        copy.titleText = titleText
        return copy
    }
    public func setTitleColor(_ titleColor: Color) -> Self{
        var copy = self
        copy.defaultTitleColor = titleColor
        return copy
    }
    public func setDarkModeTitleColor(_ titleColor: Color) -> Self{
        var copy = self
        copy.darkModeTitleColor = titleColor
        return copy
    }
    public func setTitleFont(_ titleFont: Font) -> Self{
        var copy = self
        copy.titleFont = titleFont
        return copy
    }
    public func setPlaceHolderText(_ placeHolderText: String) -> Self {
        var copy = self
        copy.placeHolderText = placeHolderText
        return copy
    }
    public func setPlaceHolderFont(_ placeHolderFont: Font) -> Self{
        var copy = self
        copy.placeHolderFont = placeHolderFont
        return copy
    }
    public func setPlaceHolderTextColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultPlaceHolderTextColor = color
        return copy
    }
    public func setDarkModePlaceHolderTextColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModePlaceHolderTextColor = color
        return copy
    }
    public func setDisable(_ disable: Binding<Bool>) -> Self{
        var copy = self
        copy.disable = disable
        return copy
    }
    public func setDisableColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultDisableColor = color
        return copy
    }
    public func setDarkModeDisableColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeDisableColor = color
        return copy
    }
    public func setError(errorText: Binding<String>, error: Binding<Bool>) -> Self {
        var copy = self
        copy.error = error
        copy.errorText = errorText
        return copy
    }
    public func setError(error: Binding<Bool>) -> Self {
        var copy = self
        copy.error = error
        return copy
    }
    public func setErrorTextColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultErrorTextColor = color
        return copy
    }
    public func setDarkModeErrorTextColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeErrorTextColor = color
        return copy
    }
    public func setErrorFont(_ errorFont: Font) -> Self{
        var copy = self
        copy.errorFont = errorFont
        return copy
    }
    public func setTrailingImage(_ image: Image, click: @escaping (()->Void)) -> Self{
        var copy = self
        copy._trailingImage = State(initialValue: image)
        copy.trailingImageClick = click
        return copy
    }
    public func setTrailingClick(_ click: @escaping (()->Void)) -> Self{
        var copy = self
        copy.trailingImageClick = click
        return copy
    }
    public func setSecureFocusLostAction(_ click: @escaping (()->Void)) -> Self{
        var copy = self
        copy.secureFocusLostAction = click
        return copy
    }
    public func setSecureText(_ secure: Bool) -> Self{
        var copy = self
        copy._secureText = State(initialValue: secure)
        if secure{
            copy._trailingImage = State(initialValue: copy.secureTextImageClose)
        }
        copy.isSecureText = secure
        return copy
    }
    public func setSecureTextImages(open: Image, close: Image) -> Self{
        var copy = self
        copy.secureTextImageOpen = open
        copy.secureTextImageClose = close
        copy._trailingImage = State(initialValue: copy.secureTextImageClose)
        return copy
    }
    public func setMaxCount(_ count: Int) -> Self{
        var copy = self
        copy.maxCount = count
        return copy
    }
    public func setTruncateMode(_ mode: Text.TruncationMode) -> Self{
        var copy = self
        copy.truncationMode = mode
        return copy
    }
    public func setBorderColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultBorderColor = color
        return copy
    }
    public func setDarkModeBorderColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeBorderColor = color
        return copy
    }
    public func setTrailingImageForegroundColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultTrailingImageForegroundColor = color
        return copy
    }
    public func setDarkModeTrailingImageForegroundColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeTrailingImageForegroundColor = color
        return copy
    }
    public func setFocusedBorderColorEnable(_ enable: Bool) -> Self{
        var copy = self
        copy.focusedBorderColorEnable = enable
        return copy
    }
    public func setFocusedBorderColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultFocusedBorderColor = color
        return copy
    }
    public func setDarkModeFocusedBorderColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeFocusedBorderColor = color
        return copy
    }
    public func setBorderWidth(_ width: CGFloat) -> Self{
        var copy = self
        copy.borderWidth = width
        return copy
    }
    public func setBackgroundColor(_ color: Color) -> Self{
        var copy = self
        copy.defaultBackgroundColor = color
        return copy
    }
    public func setDarkModeBackgroundColor(_ color: Color) -> Self{
        var copy = self
        copy.darkModeBackgroundColor = color
        return copy
    }
    public func setCornerRadius(_ radius: CGFloat) -> Self{
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
    public func setBorderType(_ type: BorderType) -> Self{
        var copy = self
        copy.borderType = type
        return copy
    }
    public func setDisableAutoCorrection(_ disable: Bool) -> Self{
        var copy = self
        copy.disableAutoCorrection = disable
        return copy
    }
    public func setTextFieldHeight(_ height: CGFloat) -> Self{
        var copy = self
        copy.textFieldHeight = height
        return copy
    }
    public func setTextContentType(_ textContentType: UITextContentType) -> Self{
        var copy = self
        copy.textContentType = textContentType
        return copy
    }
    public func setLineLimit(_ lineLimit: Int) -> Self{
        var copy = self
        copy.lineLimit = lineLimit
        return copy
    }
}

@available(iOS 13.0, *)
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
