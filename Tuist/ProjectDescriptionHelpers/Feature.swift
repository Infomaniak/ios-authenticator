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
import ProjectDescription

public protocol Dependable {
    var asDependency: TargetDependency { get }
}

extension TargetDependency: Dependable {
    public var asDependency: TargetDependency {
        return self
    }
}

public extension [Feature] {
    var asTargets: [Target] {
        return map { $0.asTarget }
    }

    var asDependencies: [TargetDependency] {
        return map { $0.asDependency }
    }
}

@frozen public struct Feature: Dependable {
    let name: String
    var targetName: String {
        "\(Constants.projectName)\(name)"
    }

    let destinations: Set<Destination>
    let dependencies: [TargetDependency]
    let additionalDependencies: [TargetDependency]
    let resources: ResourceFileElements

    public init(name: String,
                destinations: Set<Destination> = Set<Destination>([.iPhone, .iPad]),
                dependencies: [Dependable] = [TargetDependency.target(name: "\(Constants.projectName)Core"),
                                              TargetDependency.target(name: "\(Constants.projectName)CoreUI")],
                additionalDependencies: [Dependable] = [],
                resources: ResourceFileElements = []) {
        self.name = name
        self.destinations = destinations
        self.dependencies = dependencies.map { $0.asDependency }
        self.additionalDependencies = additionalDependencies.map { $0.asDependency }
        self.resources = resources
    }

    public var asTarget: Target {
        .target(name: targetName,
                destinations: destinations,
                product: Constants.productTypeBasedOnEnv,
                bundleId: "\(Constants.baseIdentifier).features.\(name)",
                deploymentTargets: Constants.deploymentTarget,
                infoPlist: .default,
                sources: "\(Constants.projectName)Features/\(name)/**",
                resources: resources,
                dependencies: dependencies + additionalDependencies,
                settings: .settings(base: Constants.baseSettings))
    }

    public var asDependency: TargetDependency {
        .target(name: targetName)
    }
}
