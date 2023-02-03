classdef jsbutton < matlab.ui.componentcontainer.ComponentContainer
    %JSBUTTON Customizable javascript button.
    %
    %   Copyright 2023 The MathWorks, Inc.

    events (HasCallbackProperty, NotifyAccess = private)
        ButtonPushed
    end % events (HasCallbackProperty, NotifyAccess = private)

    properties
        BorderBottomColor           {validatecolor} = [.5 .5 .5]
        BorderLeftColor             {validatecolor} = [.5 .5 .5]
        BorderRightColor            {validatecolor} = [.5 .5 .5]
        BorderTopColor              {validatecolor} = [.5 .5 .5]
        BorderBottomThickness (1,1) double {mustBeNonnegative} = 1
        BorderLeftThickness (1,1)   double {mustBeNonnegative} = 1
        BorderRightThickness (1,1)  double {mustBeNonnegative} = 1
        BorderTopThickness (1,1)    double {mustBeNonnegative} = 1
        BorderRadius (1,1)          double {mustBeNonnegative} = 4
        ButtonColor                 {validatecolor} = [.96 .96 .96]
        ButtonBackgroundColor       {validatecolor} = [.94 .94 .94]
        Enable (1,1)                logical = true
        FontColor                   {validatecolor} = "black"
        FontName                    {mustBeTextScalar} = "Helvetica"
        FontSize (1,1)              {mustBeNumeric, mustBePositive} = 12
        FontWeight                  TextFont = TextFont.normal
        HoverFontWeight             TextFont = TextFont.normal
        HorizontalAlignment         TextAlign = TextAlign.center
        HoverBorderBottomColor      {validatecolor} = [.5 .5 .5]
        HoverBorderLeftColor        {validatecolor} = [.5 .5 .5]
        HoverBorderRightColor       {validatecolor} = [.5 .5 .5]
        HoverBorderTopColor         {validatecolor} = [.5 .5 .5]
        HoverButtonColor            {validatecolor} = "white"
        HoverTextColor              {validatecolor} = "black"
        HoverTextUnderline (1,1)    logical = false
        Icon                        {mustBeTextScalar} = ""
        IconAlignment               IconAlign = IconAlign.right
        IconSize (1,1)              {mustBeNumeric, mustBePositive} = 20
        Text                        {mustBeTextScalar} = "Button"
    end % properties

    properties (Access = private, Transient, NonCopyable)
        HTMLComponent matlab.ui.control.HTML
    end % properties (Access = private, Transient, NonCopyable)

    properties (Access = private)
        % Create dictionary to map [HorizontalAlignment IconAlignment]
        % to [JustifyContent FlexDirection AlignItems]
        Dict = dictionary(...
            {["right" "right"]}, {["flex-start" "row-reverse" "center"]}, ...
            {["right" "left"]}, {["flex-end" "row" "center"]}, ...
            {["right" "right-margin"]}, {["flex-end" "row" "center"]}, ...
            {["right" "left-margin"]}, {["space-between" "row" "center"]}, ...
            {["right" "top"]}, {["flex-end" "column" "flex-end"]}, ...
            {["right" "bottom"]}, {["flex-start" "column-reverse" "flex-end"]}, ...
            {["center" "right"]}, {["center" "row-reverse" "center"]}, ...
            {["center" "left"]}, {["center" "row" "center"]}, ...
            {["center" "right-margin"]}, {["center" "row-reverse" "center"]}, ...
            {["center" "left-margin"]}, {["center" "row" "center"]}, ...
            {["center" "top"]}, {["center" "column" "center"]}, ...
            {["center" "bottom"]}, {["center" "column-reverse" "center"]}, ...
            {["left" "left"]}, {["flex-start" "row" "center"]}, ...
            {["left" "right"]}, {["flex-end" "row-reverse" "center"]}, ...
            {["left" "right-margin"]}, {["space-between" "row-reverse" "center"]}, ...
            {["left" "top"]}, {["space-between" "column" "baseline"]}, ...
            {["left" "bottom"]}, {["flex-start" "column-reverse" "baseline"]}, ...
            {["left" "left-margin"]}, {["flex-start" "row" "center"]})
        CSSDict = dictionary([false true], ["none" "underline"])
    end % properties (Access = private)

    methods
        function obj = jsbutton(Parent, opts)
            %JSBUTTON Class constructor
            %
            %   jsbutton(Parent, opts) creates a customizable button.
            %   Specify Parent as a container object such as uifigure,
            %   uipanel or uigridlayout, and opts as Name=Value arguments
            %   including public properties of jsbutton.

            arguments
                Parent = []
                opts.?jsbutton
            end

            % Call superconstructor to assign parent
            obj@matlab.ui.componentcontainer.ComponentContainer(Parent=Parent)
            
            % Set optional name-value pair arguments
            set(obj, opts)
        end % constructor
    end % methods

    methods (Access = protected)
        function setup(obj)
            % Create grid layout
            g = uigridlayout(obj, [1 1], Padding = [0 0 0 0]);

            % Create button
            obj.HTMLComponent = uihtml(g);
            obj.HTMLComponent.HTMLSource = "button.html";
            obj.HTMLComponent.DataChangedFcn = @(~,~) notify(obj, "ButtonPushed");
        end % setup

        function update(obj)
            % Trigger javascript callback to update button appearance
            obj.HTMLComponent.Data = struct(...
                FontSize               = obj.FontSize, ...
                FontColor              = rgb2hex(obj.FontColor), ...
                BorderRadius           = obj.BorderRadius, ...
                ButtonColor            = rgb2hex(obj.ButtonColor), ...
                BackgroundColor        = rgb2hex(obj.ButtonBackgroundColor), ...
                Enable                 = obj.Enable, ...
                Text                   = obj.Text, ...
                FontName               = obj.FontName, ...
                HoverButtonColor       = rgb2hex(obj.HoverButtonColor), ...
                HoverTextColor         = rgb2hex(obj.HoverTextColor), ...
                IconSize               = obj.IconSize, ...
                JustifyContent         = getAlignmentProp(obj, "JustifyContent"), ...
                FlexDirection          = getAlignmentProp(obj, "FlexDirection"), ...
                AlignItems             = getAlignmentProp(obj, "AlignItems"), ...
                HoverTextULine         = obj.CSSDict(obj.HoverTextUnderline), ...
                HoverBorderBottomColor = rgb2hex(obj.HoverBorderBottomColor), ...
                HoverBorderTopColor    = rgb2hex(obj.HoverBorderTopColor), ...
                HoverBorderLeftColor   = rgb2hex(obj.HoverBorderLeftColor), ...
                HoverBorderRightColor  = rgb2hex(obj.HoverBorderRightColor), ...
                BorderBottomColor      = rgb2hex(obj.BorderBottomColor), ...
                BorderBottomThickness  = obj.BorderBottomThickness, ...
                BorderLeftColor        = rgb2hex(obj.BorderLeftColor), ...
                BorderLeftThickness    = obj.BorderLeftThickness, ...
                BorderRightColor       = rgb2hex(obj.BorderRightColor), ...
                BorderRightThickness   = obj.BorderRightThickness, ...
                BorderTopColor         = rgb2hex(obj.BorderTopColor), ...
                BorderTopThickness     = obj.BorderTopThickness, ...
                FontWeight             = obj.FontWeight, ...
                HoverFontWeight        = obj.HoverFontWeight, ...
                Icon                   = obj.Icon);
  
            function out = rgb2hex(rgb)
                % Convert RGB to hexadecimal representation
                rgb = validatecolor(rgb);
                hex = dec2hex(round(255*rgb));
                out = ['#' hex(1,:) hex(2,:) hex(3,:)];
            end % rgb2hex
        end % update
    end % methods (Access = protected)

    methods (Access = private)
        function x = getAlignmentProp(obj, PropName)
            d = dictionary(["JustifyContent" "FlexDirection" "AlignItems"], 1:3);
            x = obj.Dict({[obj.HorizontalAlignment.Name, obj.IconAlignment.Name]});
            x = x{1}(d(PropName));
        end % getAlignmentProp
    end % methods (Access = private)
end % classdef