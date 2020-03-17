//
//  MainViewController.swift
//  Master
//
//  Created by Luis Carlos Mejia Garcia on 12/26/19.
//  Copyright © 2019 Master. All rights reserved.
//

import UIKit
import GoogleSignIn
import AVFoundation
import Hero

class MainViewController: UIViewController {
    // MARK: - UI References
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var emailLoginButton: MButton!
    @IBOutlet private weak var registerButton: MButton!
    @IBOutlet private weak var signInButton: GIDSignInButton!
    
    // MARK: - UI References
    @IBAction func emailLoginButtonAction() {
        router?.transition(to: .emailLogin)
    }
    
    @IBAction func registerButtonAction() {
        router?.transition(to: .register)
    }
    
    // MARK: - Properties
    var router: RouterBase<MainRouterTransitions>?
    private let heroTransition = HeroTransition()
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    private var paused = false
    private let viewModel = MainViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avPlayerLayer?.frame = view.layer.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        avPlayer?.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        stopVideo()
    }
    
    // MARK: - Public Methods
    func destroyVideoReference() {
        avPlayer = nil
        avPlayerLayer = nil
        videoView.removeFromSuperview()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        title = ""
        
        setupBindings()
        
        setupVideo()
        
        disableTitle()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        setupGoogleAuth()
    }
    
    private func setupBindings() {
        viewModel.isLoading.listen { isLoading in
            isLoading ? Loader.show() : Loader.dismiss()
        }
        
        viewModel.controlsEnabled.bindTo(emailLoginButton, to: .state)
        viewModel.controlsEnabled.bindTo(registerButton, to: .state)
        
        viewModel.status.listen { [weak self] status in
            guard let self = self else { return }
            
            switch status {
            case .gmailLoginReady:
                self.router?.transition(to: .home)
                
            case .error(let error):
                self.showError(message: error)
                
            default:
                return
            }
        }
    }
    
    private func setupGoogleAuth() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        GIDSignIn.sharedInstance()?.clientID = viewModel.googleClientID
    }
}

// MARK: - Video Methods
extension MainViewController {
    private func stopVideo() {
        avPlayer?.pause()
        paused = true
    }
    
    private func setupVideo() {
        guard let videoUrl = Bundle.main.url(forResource: viewModel.videoName,
                                             withExtension: viewModel.videoExtension) else {
                                                return
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        
        avPlayer = AVPlayer(url: videoUrl)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer?.videoGravity = .resizeAspectFill
        avPlayer?.isMuted = true
        avPlayer?.actionAtItemEnd = .none
        
        avPlayerLayer?.frame = videoView.layer.bounds
        videoView.layer.insertSublayer(avPlayerLayer ?? AVPlayerLayer(), at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(_ :)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer?.currentItem)
    }
    
    @objc private func playerItemDidReachEnd(_ notification: Notification) {
        if let player: AVPlayerItem = notification.object as? AVPlayerItem {
            player.seek(to: .zero, completionHandler: nil)
        }
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension MainViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}

// MARK: - GIDSignInDelegate
extension MainViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn, didSignInFor user: GIDGoogleUser, withError error: Error) {
        guard let profile = user.profile else {
            return
        }
        
        let photoURL = profile.imageURL(withDimension: 400)?.absoluteString
        
        viewModel.gmailLogin(photoUrl: photoURL ?? "",
                             id: user.userID,
                             gmailToken: user.authentication.idToken,
                             email: profile.email,
                             names: (profile.givenName, profile.familyName))
    }
    
    func sign(_ signIn: GIDSignIn, didDisconnectWith user: GIDGoogleUser, withError error: Error!) {}
}
