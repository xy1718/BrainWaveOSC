#include "ofxTouchGUITextInput.h"

// text input only works on ios atm

ofxTouchGUITextInput::ofxTouchGUITextInput(){

    keyboardSet = false;
    wasKeyboardOpen = false;
    //input = "";
    //placeHolderInput = "";
    fontColor = ofColor(40,40,40,255);
    fontSize = 16;
    defaultInput = "";
}

ofxTouchGUITextInput::~ofxTouchGUITextInput(){
	
}

void ofxTouchGUITextInput::resetDefaultValue(){
    
    #ifdef TARGET_OF_IPHONE
        if(keyboardSet) {
            keyboard->setText(defaultInput);
        }
    #endif
}

void ofxTouchGUITextInput::setInput(string *placeHolderText) {
    
    //placeHolderInput = placeHolderText;
    
    #ifdef TARGET_OF_IPHONE
    
        if(!keyboardSet) {
            
            // setting up a keyboard with some basic defaults...
            keyboard = new ofxiPhoneKeyboard(posX, posY + height, width, height);
            
            //hide the keyboard far far away
            //keyboard = new ofxiPhoneKeyboardExtra(-5000, 0, 10, 10);
            keyboard->setVisible(true);
            //keyboard->setMaxChars(100);
            keyboard->setBgColor(255, 255, 255, 255); // retina weirdness if(retina) 
            keyboard->setFontColor(fontColor.r,fontColor.g,fontColor.b,fontColor.a);
            keyboard->setFontSize(fontSize);
            //keyboard->disableAutoCorrection(); // disable auto type corrections, custom method added to ofxIphoneKeyboard.
            keyboard->updateOrientation();
            //keyboard->setPlaceholder(placeHolderText);
            keyboard->setPosition(posX, posY + height);
            
            // register update events?
            //ofAddListener(ofEvents().update, this, &ofxTouchGUITextInput::updateKeyboard);
        }
        
        keyboard->setText(*placeHolderText);
        input = placeHolderText;
        //defaultInput = *placeHolderText;
        keyboardSet = true;
    
    #endif
    
}

string ofxTouchGUITextInput::getInput() {
    return *input;
}

//ofEventArgs &e
void ofxTouchGUITextInput::updateKeyboard()
{
    #ifdef TARGET_OF_IPHONE
        *input = keyboard->getLabelText(); 
        
        if(keyboard->isKeyboardShowing()) {
            wasKeyboardOpen = true;
        } else {
            if(wasKeyboardOpen) {
                onKeyboardInput();
            }
            wasKeyboardOpen = false;
        }
    #endif
}


void ofxTouchGUITextInput::onKeyboardInput()
{    
    //input = keyboard->getLabelText(); 
    cout << "input: " << *input << endl;
    ofNotifyEvent(onChangedEvent,*input,this);
    sendOSC(*input);
}

void ofxTouchGUITextInput::hide(){
    #ifdef TARGET_OF_IPHONE
        keyboard->setVisible(false);
    
    #endif
    ofxTouchGUIBase::hide();
}

void ofxTouchGUITextInput::show(bool activateSingleItem){
    #ifdef TARGET_OF_IPHONE
        keyboard->setVisible(true);
    #endif
    ofxTouchGUIBase::show(activateSingleItem);
}
    
//--------------------------------------------------------------
void ofxTouchGUITextInput::draw(){
    
    // not the best place to put this
    #ifdef TARGET_OF_IPHONE
        updateKeyboard();
    #endif
    /*
    if(!isHidden) {
        ofPushMatrix();
        ofTranslate(int(posX), int(posY));
        
        // draw the background rectangle
        if(isPressed) {
            drawGLRect(vertexArrActive, colorsArrActive);
        }
        else {
            drawGLRect(vertexArr, colorsArr);
        }
        
        // draw text
        ofPushStyle();
        ofSetColor(textColourLight);
        drawText(label, 1);
        ofPopStyle();
        
        ofPopMatrix();
    }*/
     
}



