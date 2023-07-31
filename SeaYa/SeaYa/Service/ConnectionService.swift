//
//  ConnectionService.swift
//  SeaYa
//
//  Created by hyebin on 2023/07/24.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

struct Peer: Hashable {
    var peer: MCPeerID
    var value: String
}

class ConnectionService: NSObject, ObservableObject {
    private static let service = "ou-SeaYa"
   
    //MARK: all connected guest list
    @Published var peers: [(peer: MCPeerID, value: String)] = []
    @Published var foundPeers: [Peer] = []
//    @Published var foundPeers: [(peer: MCPeerID, value: String)] = []
    @Published var connected = false
    @Published var groupInfo: GroupInfo?
    @Published var listUP: [DateMember] = []
    @Published var scheduleDone: ScheduleDone?

    private var advertiserAssistant: MCNearbyServiceAdvertiser?
    var session: MCSession?
    var browser: MCNearbyServiceBrowser?
    
    //MARK: true - Guest, false - Host
    private var isHosting = false
    
    func host(_ nickName: String) {
        let myPeerId = MCPeerID(displayName: nickName)
        
        peers.removeAll()
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
        
        let serviceType = ConnectionService.service
        
        browser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }
    
    func guest(_ nickName: String, _ index: String) {
        let myPeerId = MCPeerID(displayName: nickName)
        
        isHosting = true
        peers.removeAll()
        connected = true
        session = MCSession(
            peer: myPeerId,
            securityIdentity: nil,
            encryptionPreference: .required
        )

        session?.delegate = self
        advertiserAssistant = MCNearbyServiceAdvertiser(
            peer: myPeerId,
            discoveryInfo: [nickName: index],
            serviceType: ConnectionService.service
        )
        
        advertiserAssistant?.delegate = self
        advertiserAssistant?.startAdvertisingPeer()
        
        print(myPeerId)
    }
    
    func send<T: Codable>(_ data: T, messageType: MessageType) {
        guard
            let session = session,
            !session.connectedPeers.isEmpty
        else { return }
        
        let messageWrapper = MessageWrapper(messageType: messageType, data: data)
        do {
            let encodedData = try JSONEncoder().encode(messageWrapper)
            try session.send(encodedData, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func leaveSession() {
        isHosting = false
        connected = false
        advertiserAssistant?.stopAdvertisingPeer()
        session = nil
        advertiserAssistant = nil
    }
    
    func sendGroupInfoToGuest(_ info: GroupInfo) {
        send(info, messageType: .GroupInfo)
    }
    
    func sendTimeTableInfoToHost(_ info: DateMember) {
        send(info, messageType: .ListUP)
    }
    
    func sendScheduleInfoToGuest(_ info: ScheduleDone) {
        send(info, messageType: .ScheduleDone)
    }
}

extension ConnectionService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}


extension ConnectionService: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let messageTypeString = json?["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString),
               let jsonData = json?["data"] as? [String: Any] {
                switch messageType {
                case .GroupInfo:
                    if let groupInfoData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        groupInfo = try JSONDecoder().decode(GroupInfo.self, from: groupInfoData)
                        print(groupInfo ?? "")
                    }
                    
                case .ListUP:
                    if let listUPData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let data = try JSONDecoder().decode(DateMember.self, from: listUPData)
                        listUP.append(data)
                        print(listUP ?? "")
                    }
                    
                case .ScheduleDone:
                    if let groupDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        scheduleDone = try JSONDecoder().decode(ScheduleDone.self, from: groupDoneData)
                        print(scheduleDone ?? "")
                    }
                }
            }
        } catch {
            print("Decoding error: \(error)")
        }
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            if !peers.contains(where: {$0.peer == peerID}) && peers.count < 7{
                DispatchQueue.main.async {
                    self.peers.append((peer: peerID, value: self.foundPeers.filter{$0.peer == peerID}.first?.value ?? "01"))
                    print("connected")
                }
            }
            
        case .notConnected:
            DispatchQueue.main.async {
                print("not connected")
                
                if let index = self.peers.firstIndex(where: {$0.peer == peerID}) {
                    self.peers.remove(at: index)
                }
                if self.peers.isEmpty && !self.isHosting {
                    self.connected = false
                }
            }
        case .connecting:
            print("Connecting to: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state: \(state)")
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Receiving chat history")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        guard
            let localURL = localURL,
            let data = try? Data(contentsOf: localURL)
        else { return }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let messageTypeString = json?["messageType"] as? String,
               let messageType = MessageType(rawValue: messageTypeString),
               let jsonData = json?["data"] as? [String: Any] {
                switch messageType {
                case .GroupInfo:
                    if let groupInfoData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        groupInfo = try JSONDecoder().decode(GroupInfo.self, from: groupInfoData)
                        print(groupInfo ?? "")
                    }
                    
                case .ListUP:
                    if let listUPData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        let data = try JSONDecoder().decode(DateMember.self, from: listUPData)
                        listUP.append(data)
                        print(listUP ?? "")
                    }
                    
                case .ScheduleDone:
                    if let groupDoneData = try? JSONSerialization.data(withJSONObject: jsonData) {
                        scheduleDone = try JSONDecoder().decode(ScheduleDone.self, from: groupDoneData)
                        print(scheduleDone ?? "")
                    }
                }
            }
        } catch {
            print("Decoding error: \(error)")
        }
    }
}
    
extension ConnectionService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        //MARK: value 수정
        if !self.foundPeers.contains(where: {$0.peer == peerID }){
            if let value = info?.first?.value {
                self.foundPeers.append(Peer(peer: peerID, value: "01"))
            }
           // self.foundPeers.append(Peer(peer: peerID, value: "01"))
        }
        
        print(self.foundPeers)
    }
        
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print(peerID)
        if let index = foundPeers.firstIndex(where: {$0.peer == peerID}) {
            foundPeers.remove(at: index)
        }
    }
}