//
//  EGTextFieldConfig.swift
//  CustomEdittext
//
//  Created by Esat Gözcü on 2023/04/03.
//

import SwiftUI

@available(iOS 13.0, *)
public class EGTextFieldConfig{
    public static var shared = EGTextFieldConfig()
    private init(){}
    
    //Text Color
    public var defaultTextColor : Color = .black
    public var darkModeTextColor : Color = .white
    //Title Color
    public var defaultTitleColor : Color = .black
    public var darkModeTitleColor : Color = .white
    //PlaceHolder Text Color
    public var defaultPlaceHolderTextColor : Color = .gray.opacity(0.8)
    public var darkModePlaceHolderTextColor : Color = .white.opacity(0.3)
    //Disable Color
    public var defaultDisableColor : Color = .gray.opacity(0.5)
    public var darkModeDisableColor : Color = .gray.opacity(0.3)
    //Background Color
    public var defaultBackgroundColor : Color = .white
    public var darkModeBackgroundColor : Color = .black
    //Error Text Color
    public var defaultErrorTextColor : Color = .red
    public var darkModeErrorTextColor : Color = .red
    //Border Color
    public var defaultBorderColor : Color = .gray
    public var darkModeBorderColor : Color = .white.opacity(0.7)
    //Trailing Image Color
    public var defaultTrailingImageForegroundColor : Color = .black
    public var darkModeTrailingImageForegroundColor : Color = .white
    //Focused Border Color
    public var focusedBorderColorEnable: Bool = false
    public var defaultFocusedBorderColor : Color = .black
    public var darkModeFocusedBorderColor : Color = .white
    //Font
    public var titleFont : Font = .callout
    public var textFont : Font = .callout
    public var errorFont : Font = .footnote
    public var placeHolderFont : Font = .subheadline
    //Default
    public var borderWidth : CGFloat = 1.0
    public var cornerRadius : CGFloat = 5.0
    public var borderType: BorderType = .square
    public var disableAutoCorrection: Bool = false
    public var textFieldHeight : CGFloat = 45
    public var textContentType : UITextContentType?
}

public enum BorderType {
    case square
    case line
}
