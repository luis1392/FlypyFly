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
    var texturaMosca1 = SKTexture()
    var  texturaFondo = SKTexture()
    
    enum tipoNodo: UInt32 {
        
        
        case mosca = 1
        
        case tuboSuelo = 2
        
        case espacioTubos = 4
        
        
    }
    
    override func didMove(to view: SKView) {
        
        // Delegado para detectar coliciones
        self.physicsWorld.contactDelegate = self
        
        //TIMER  TUBOS 
        _ = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.crearTubos), userInfo: nil, repeats: true)
        
        
        //MOSCA
        crearMosca()
        
        //FONDO ANIMADO
        crearFondoAnimado()
        
        //SUELO
        crearSuelo()
        
        //TUBOS
        crearTubos()
        

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
        
        self.addChild(suelo)
    }
    
    
    func crearTubos() {
        
        let moverTubos =  SKAction.move(by: CGVector(dx:-3 * self.frame.width, dy: 0 ), duration: TimeInterval(self.frame.width / 100 ) )
        
        let removerTubos = SKAction.removeFromParent()
        //nivel de dificultad
        let gapDificultad = mosca.size.height * 3
        
        let moverAndRemoverTubos = SKAction.sequence( [moverTubos,removerTubos] )
        
       
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
        
        
        tubo1.run(moverAndRemoverTubos)
        tubo2.run(moverAndRemoverTubos)
        
        self.addChild(tubo1)
        self.addChild(tubo2)
        
        
        
        
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
        
        
        mosca.run(animacionInfinita)
        mosca.zPosition = 1
        self.addChild(mosca)
    }
    
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        mosca.physicsBody = SKPhysicsBody(circleOfRadius: texturaMosca1.size().height/2)
        mosca.physicsBody!.isDynamic = true
        mosca.physicsBody!.velocity = ( CGVector(dx:0, dy:0)  )
        mosca.physicsBody!.applyImpulse( CGVector(dx:0, dy:100) )
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        <#code#>
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
