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
        id: "1",
        name: "Laura Snow",
        email: "laura.snow@ik.me",
        profilePictureURL: URL(string: ""),
        status: .protected
    )

    public static let sampleUIAccounts = [
        UIAccount(
            id: "1",
            name: "Laura Snow",
            email: "laura.snow@ik.me",
            profilePictureURL: URL(
                string: "https://media.4-paws.org/1/2/6/0/1260b8bbeb9d82d5a6caaa078d5061bbf626f94e/VIER%20PFOTEN_2015-04-27_010-1927x1333-1920x1328.jpg"
            ),
            status: .protected
        ),
        UIAccount(
            id: "2",
            name: "John Appleseed",
            email: "john.apple@etik.com",
            profilePictureURL: URL(string: ""),
            status: .partiallyProtected
        ),
        UIAccount(
            id: "3",
            name: "Paul Anderson",
            email: "paul.anderson@infomaniak.com",
            profilePictureURL: URL(string: ""),
            status: .protected
        )
    ]
}
