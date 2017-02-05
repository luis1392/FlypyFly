//
//  GameScene.swift
//  FlypyFly
//
//  Created by Luis Enrique Tierrafria Rodriguez on 2/2/17.
//  Copyright © 2017 Luis Enrique Tierrafria Rodriguez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mosca = SKSpriteNode()
    var fondo = SKSpriteNode()
    var tubo1 = SKSpriteNode()
    var tubo2 = SKSpriteNode()
    //var boton = SKSpriteNode()
    var texturaMosca1 = SKTexture()
    var  texturaFondo = SKTexture()
    var labelPuntuacion = SKLabelNode()
    var puntuacion = 0
    var timer = Timer()
    var gameOver = false
    var boton = UIButton()
    
    
    
    
    /*
     La propiedad categoryBitMask es un número que define el tipo de objetos que el cuerpo fisico del nodo tendrá y es considerado para las colisiones y contactos
     
     La propiedad collisionBitMask es un número que define con cuales categorias de objetos este nodo deberia colicionar.
     
     La propiedad contactTestBitMask es un número que define cuelas colisiones nos seran notificadas
     
     
     */
    
    enum tipoNodo: UInt32 {
        
        
        case mosca = 1
        
        case tuboSuelo = 2
        
        case espacioTubos = 4
        
        
    }
    
    override func didMove(to view: SKView) {
        
        // Delegado para detectar coliciones
        self.physicsWorld.contactDelegate = self
        
       reiniciar()

    }
    
    func crearLabelPuntuacion(){
    
        labelPuntuacion.fontName = "Arial"
        
        labelPuntuacion.fontSize = 80
        
        labelPuntuacion.text = "0"
        labelPuntuacion.position = CGPoint(x:self.frame.midX, y: self.frame.midY + 500)
        labelPuntuacion.zPosition = 2
        
        self.addChild(labelPuntuacion)
    
    }
    
    
    func crearFondoAnimado(){
        //FONDO ANIMADO
        texturaFondo = SKTexture(imageNamed: "fondo.png")
        let movimientoFondo = SKAction.move(by: CGVector(dx: -texturaFondo.size().width,dy:0), duration: 4)
        
        let movimientoFondoOrigen = SKAction.move(by: CGVector(dx: texturaFondo.size().width, dy: 0), duration: 0)
        
        let movimientoInfinitoFondo = SKAction.repeatForever(SKAction.sequence([movimientoFondo,movimientoFondoOrigen]) )
        
        
        var i:CGFloat = 0
        
        while i<2 {
            
            fondo = SKSpriteNode(texture: texturaFondo)
            fondo.position = CGPoint(x:texturaFondo.size().width * i, y: self.frame.midY)
            
            fondo.size.height = self.frame.height //Fondo igual al alto de la pantalla
            fondo.zPosition = -1
            fondo.run(movimientoInfinitoFondo)
            
            self.addChild(fondo)
            
            i += 1
        }
    }
    
    
    func crearSuelo() {
        let suelo = SKNode()
        
        suelo.position = CGPoint(x:-self.frame.midX, y:-self.frame.height/2)
        
        suelo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:self.frame.width, height: 1) )
        
        suelo.physicsBody!.isDynamic = false
        
        suelo.physicsBody!.categoryBitMask = tipoNodo.tuboSuelo.rawValue
        
        //con que objetos podra colisionar
        suelo.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        
        suelo.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        
        self.addChild(suelo)
    }
    
    
    func crearTubosAndEspacios () {
        
        let moverTubos =  SKAction.move(by: CGVector(dx:-3 * self.frame.width, dy: 0 ), duration: TimeInterval(self.frame.width / 100 ) )
        
        let removerTubos = SKAction.removeFromParent()
        let moverAndRemoverTubos = SKAction.sequence( [moverTubos,removerTubos] )
        
        //nivel de dificultad
        let gapDificultad = mosca.size.height * 3
        
       
        let cantidadMovimientoAleatorio = CGFloat( arc4random() %  UInt32(self.frame.height/2) )
        
        let compensacionTubos = cantidadMovimientoAleatorio - self.frame.height/4
        
        //Crear textura para los tubos
        let texturaTubo1 = SKTexture(imageNamed: "Tubo1.png")
        let texturaTubo2 = SKTexture(imageNamed: "Tubo2.png")
        
        tubo1 = SKSpriteNode(texture: texturaTubo1)
        tubo1.position = CGPoint(x: self.frame.midX + self.frame.width, y:self.frame.midY + texturaTubo1.size().height/2 + gapDificultad + compensacionTubos)
        tubo1.zPosition = 0
        
        
        tubo2 = SKSpriteNode(texture: texturaTubo2)
        tubo2.position = CGPoint(x: self.frame.midX  + self.frame.width, y:self.frame.midY - texturaTubo2.size().height/2 - gapDificultad + compensacionTubos )
        tubo2.zPosition = 0
        
        
        tubo1.physicsBody = SKPhysicsBody( rectangleOf: texturaTubo1.size() ) //Creamos cuerpo fisico al tubo
        tubo1.physicsBody!.isDynamic = false
        
        tubo2.physicsBody = SKPhysicsBody( rectangleOf: texturaTubo1.size() ) //Creamos cuerpo fisico al tubo
        tubo2.physicsBody!.isDynamic = false
        
        //define el tipo de objetos que el cuerpo fisico del nodo tendrá
        tubo1.physicsBody!.categoryBitMask = tipoNodo.tuboSuelo.rawValue
        tubo2.physicsBody!.categoryBitMask = tipoNodo.tuboSuelo.rawValue
        
        //con que objetos podra colisionar
        tubo1.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        tubo2.physicsBody!.collisionBitMask = tipoNodo.mosca.rawValue
        
        tubo1.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        tubo2.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        
        tubo1.run(moverAndRemoverTubos)
        tubo2.run(moverAndRemoverTubos)
        
        self.addChild(tubo1)
        self.addChild(tubo2)
        
        
        // Espacios
        
        
        let espacio = SKSpriteNode()
        espacio.position = CGPoint(x:self.frame.midX + self.frame.width , y:self.frame.midY + compensacionTubos)
        
        espacio.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width:texturaTubo1.size().width , height: mosca.size.height * 3))
        
        espacio.physicsBody!.isDynamic = false //El cuerpo fisico no sea afectado por la grabedad
        espacio.zPosition = 1
        
        //define el tipo de objetos que el cuerpo fisico del nodo tendrá
        espacio.physicsBody!.categoryBitMask = tipoNodo.espacioTubos.rawValue
        
        //El espacio no puede colicionar con otro nodo
        espacio.physicsBody!.collisionBitMask = 0
        
        espacio.physicsBody!.contactTestBitMask = tipoNodo.mosca.rawValue
        
        
        espacio.run(moverAndRemoverTubos) //Ejecutar Accion
        
        
        self.addChild(espacio)  //Agregar al nodo padre
        
        
        
        
    }
    
    
    
    
    func crearMosca() {
        //primera textura de la imagen mosca
        texturaMosca1 = SKTexture(imageNamed: "fly1.png")
        let texturaMosca2 = SKTexture(imageNamed: "fly2.png")
        
        //acciones de la mosca
        let animacion = SKAction.animate(with: [texturaMosca1,texturaMosca2], timePerFrame: 0.1)
        let animacionInfinita = SKAction.repeatForever(animacion)
        
        mosca = SKSpriteNode(texture: texturaMosca1)
        
        mosca.position = CGPoint(x:self.frame.midX ,y:self.frame.midY)
        
        //Crear cuerpo fisico a la mosca
        mosca.physicsBody = SKPhysicsBody(circleOfRadius: texturaMosca1.size().height/2)
        mosca.physicsBody?.isDynamic = false  //No es afecta por la gravedad
        
        //define el tipo de objetos que el cuerpo fisico del nodo tendrá
        mosca.physicsBody!.categoryBitMask = tipoNodo.mosca.rawValue
        
        
        //con que objetos podra colisionar
        mosca.physicsBody!.collisionBitMask = tipoNodo.tuboSuelo.rawValue
        
        //notificar colicion ya sea con un tubo o el suelo
        mosca.physicsBody!.contactTestBitMask = tipoNodo.tuboSuelo.rawValue | tipoNodo.espacioTubos.rawValue
        
        mosca.run(animacionInfinita)
        mosca.zPosition = 1
        self.addChild(mosca)
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if gameOver == false  {
            mosca.physicsBody!.isDynamic = true // Al tocar la pantalla es afectada por la gravedad
            mosca.physicsBody!.velocity = ( CGVector(dx:0, dy:0)  )
            mosca.physicsBody!.applyImpulse( CGVector(dx:0, dy:100) ) // inpulso generado al tocar la pantalla
        }
        else{
            /*boton.color = SKColor.yellow
            boton.position = CGPoint(x:self.frame.midX  , y:self.frame.midY)
            boton.size = CGSize(width:60, height: 40)
            boton.isUserInteractionEnabled = true
            boton.canPerformAction(<#T##action: Selector##Selector#>, withSender: <#T##Any?#>)
            
            
            self.addChild(boton) */

            
        }
   
        
        
    }
    
    func getInicio()  {
        boton.isHidden = true
        gameOver = false
        puntuacion = 0
        self.speed = 1
        self.removeAllChildren()
        reiniciar()
    }
    
    func reiniciar() {
    
        
        //TIMER  TUBOS
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.crearTubosAndEspacios), userInfo: nil, repeats: true)
        
        //LABEL PUNTUACION
        crearLabelPuntuacion()
        
        
        //MOSCA
        crearMosca()
        
        //FONDO ANIMADO
        crearFondoAnimado()
        
        //SUELO
        crearSuelo()
        
        //TUBOS Y ESPACIO ENTRE TUBOS
        crearTubosAndEspacios()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let cuerpoA = contact.bodyA
        let cuerpoB = contact.bodyB
        
        if (cuerpoA.categoryBitMask == tipoNodo.mosca.rawValue && cuerpoB.categoryBitMask == tipoNodo.espacioTubos.rawValue) || (cuerpoA.categoryBitMask == tipoNodo.espacioTubos.rawValue && cuerpoB.categoryBitMask == tipoNodo.mosca.rawValue) {
            
            puntuacion += 1
            labelPuntuacion.text = String(puntuacion)
        }
        else{
            boton.frame = CGRect(x:self.frame.midX, y:50, width:200, height: 40)
            boton.setTitle("Reiniciar", for: UIControlState.normal)
            boton.setTitleColor(UIColor.black, for: .normal)
            boton.backgroundColor = UIColor.yellow
            boton.addTarget(self, action: #selector(self.getInicio), for: .touchDown)
            self.view!.addSubview(boton)
            boton.isHidden = false
            
            gameOver = true
            self.speed = 0
            timer.invalidate()
            labelPuntuacion.text = String("GAME OVER")
            
        }
        
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
