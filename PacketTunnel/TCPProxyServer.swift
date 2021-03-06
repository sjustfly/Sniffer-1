//
//  TCPProxyServer.swift
//  Sniffer
//
//  Created by ZapCannon87 on 02/05/2017.
//  Copyright © 2017 zapcannon87. All rights reserved.
//

import Foundation
import NetworkExtension
import ZPTCPIPStack

class TCPProxyServer: NSObject {
    
    let server: ZPPacketTunnel
    
    fileprivate var index: Int = 0
    
    fileprivate var connections: Set<TCPConnection> = []
    
    override init() {
        self.server = ZPPacketTunnel.shared()
        super.init()
        self.server.setDelegate(
            self,
            delegateQueue: DispatchQueue(label: "TCPProxyServer.delegateQueue")
        )
    }
    
    func remove(connection: TCPConnection) {
        self.server.delegateQueue.async {
            self.connections.remove(connection)
        }
    }
    
}

extension TCPProxyServer: ZPPacketTunnelDelegate {
    
    func tunnel(_ tunnel: ZPPacketTunnel, didEstablishNewTCPConnection conn: ZPTCPConnection) {
        if let tcpConn: TCPConnection = TCPConnection(
            index: self.index,
            localSocket: conn,
            server: self)
        {
            self.index += 1
            self.connections.insert(tcpConn)
        }
    }
    
}
