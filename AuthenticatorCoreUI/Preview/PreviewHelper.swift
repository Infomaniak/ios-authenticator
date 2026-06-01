/*
 Infomaniak Authenticator - iOS App
 Copyright (C) 2026 Infomaniak Network SA

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation

public enum PreviewHelper {
    public static let sampleUIAccount = UIAccount(
        id: 1,
        name: "Laura Snow",
        email: "laura.snow@ik.me",
        profilePictureURL: nil,
        status: .protected
    )

    public static let sampleUIAccount2 = UIAccount(
        id: 2,
        name: "John Appleseed",
        email: "john.apple@etik.com",
        profilePictureURL: nil,
        status: .partiallyProtected
    )

    public static let sampleUIAccount3 = UIAccount(
        id: 3,
        name: "Paul Anderson",
        email: "paul.anderson@infomaniak.com",
        profilePictureURL: nil,
        status: .loggedOut
    )

    public static let sampleUIAccount4 = UIAccount(
        id: 4,
        name: "Paul Anderson",
        email: "paul.anderson@infomaniak.com",
        profilePictureURL: nil,
        status: .loginFailed
    )

    public static let sampleUIAccount5 = UIAccount(
        id: 5,
        name: "Paul Anderson",
        email: "paul.anderson@infomaniak.com",
        profilePictureURL: nil,
        status: .loginFailedRetriable
    )

    public static let sampleUIAccounts = [
        Self.sampleUIAccount,
        Self.sampleUIAccount2,
        Self.sampleUIAccount3
    ]

    @MainActor
    public static let sampleMainViewState = MainViewState(accounts: sampleUIAccounts)
}
