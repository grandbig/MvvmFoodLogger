//
//  ViewController+Alert.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/09/10.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    /// 警告モーダルの表示処理
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - completion: OKタップ時のCallback
    internal func showAlert(title: String = R.string.common.confirm(),
                            message: String,
                            completion: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction.init(title: R.string.common.ok(), style: UIAlertAction.Style.default) { _ in
            completion()
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

    /// 確認モーダルの表示処理
    ///
    /// - Parameters:
    ///   - title: タイトル
    ///   - message: メッセージ
    ///   - okCompletion: OKタップ時のCallback
    ///   - cancelCompletion: Cancelタップ時のCallback
    internal func showConfirm(title: String = R.string.common.confirm(),
                              message: String,
                              okCompletion: @escaping (() -> Void),
                              cancelCompletion: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction.init(title: R.string.common.ok(), style: UIAlertAction.Style.default) { _ in
            okCompletion()
        }
        let cancelAction = UIAlertAction.init(title: R.string.common.cancel(), style: UIAlertAction.Style.cancel) { _ in
            cancelCompletion()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    /// 確認アクションシートの表示処理
    ///
    /// - Parameters:
    ///   - message: タイトル
    ///   - firstActionTitle: 1つ目のアクション名
    ///   - secondActionTitle: 2つ目のアクション名
    ///   - firstCompletion: 1つ目のアクションタップ時のCallback
    ///   - secondCompletion: 2つ目のアクションタップ時のCallback
    internal func showActionSheet(
        message: String,
        firstActionTitle: String,
        secondActionTitle: String,
        firstCompletion: @escaping(() -> Void),
        secondCompletion: @escaping (() -> Void)) {
        let alert = UIAlertController.init(title: R.string.common.confirm(),
                                           message: message,
                                           preferredStyle: UIAlertController.Style.actionSheet)
        let firstAction = UIAlertAction.init(title: firstActionTitle, style: UIAlertAction.Style.default) { _ in
            firstCompletion()
        }
        let secondAction = UIAlertAction.init(title: secondActionTitle, style: UIAlertAction.Style.default) { _ in
            secondCompletion()
        }
        let cancelAction = UIAlertAction.init(title: R.string.common.cancel(), style: UIAlertAction.Style.cancel) { _ in
        }
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
