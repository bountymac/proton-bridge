// Copyright (c) 2021 Proton Technologies AG
//
// This file is part of ProtonMail Bridge.
//
// ProtonMail Bridge is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// ProtonMail Bridge is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with ProtonMail Bridge.  If not, see <https://www.gnu.org/licenses/>.

// +build build_qt

// Package qt provides communication between Qt/QML frontend and Go backend
package qt

import (
	"fmt"
	"sync"

	"github.com/ProtonMail/go-autostart"
	"github.com/ProtonMail/proton-bridge/internal/config/settings"
	"github.com/ProtonMail/proton-bridge/internal/config/useragent"
	"github.com/ProtonMail/proton-bridge/internal/frontend/types"
	"github.com/ProtonMail/proton-bridge/internal/locations"
	"github.com/ProtonMail/proton-bridge/internal/updater"
	"github.com/ProtonMail/proton-bridge/pkg/listener"
	"github.com/ProtonMail/proton-bridge/pkg/pmapi"
	"github.com/sirupsen/logrus"
	"github.com/therecipe/qt/qml"
	"github.com/therecipe/qt/widgets"
)

type FrontendQt struct {
	programName, programVersion string

	panicHandler     types.PanicHandler
	locations        *locations.Locations
	settings         *settings.Settings
	eventListener    listener.Listener
	updater          types.Updater
	userAgent        *useragent.UserAgent
	bridge           types.Bridger
	noEncConfirmator types.NoEncConfirmator
	autostart        *autostart.App
	restarter        types.Restarter

	authClient pmapi.Client
	auth       *pmapi.Auth
	password   []byte

	newVersionInfo updater.VersionInfo

	log      *logrus.Entry
	usersMtx sync.Mutex

	app    *widgets.QApplication
	engine *qml.QQmlApplicationEngine
	qml    *QMLBackend
}

func New(
	version,
	buildVersion,
	programName string,
	showWindowOnStart bool,
	panicHandler types.PanicHandler,
	locations *locations.Locations,
	settings *settings.Settings,
	eventListener listener.Listener,
	updater types.Updater,
	userAgent *useragent.UserAgent,
	bridge types.Bridger,
	_ types.NoEncConfirmator,
	autostart *autostart.App,
	restarter types.Restarter,
) *FrontendQt {
	return &FrontendQt{
		programName:    "Proton Mail Bridge",
		programVersion: version,
		log:            logrus.WithField("pkg", "frontend/qt"),

		panicHandler:  panicHandler,
		locations:     locations,
		settings:      settings,
		eventListener: eventListener,
		updater:       updater,
		userAgent:     userAgent,
		bridge:        bridge,
		autostart:     autostart,
		restarter:     restarter,
	}
}

func (f *FrontendQt) Loop() error {
	err := f.initiateQtApplication()
	if err != nil {
		return err
	}

	go func() {
		defer f.panicHandler.HandlePanic()
		f.watchEvents()
	}()

	if ret := f.app.Exec(); ret != 0 {
		err := fmt.Errorf("Event loop ended with return value: %v", ret)
		f.log.Warn("App exec", err)
		return err
	}

	return nil
}

func (f *FrontendQt) NotifyManualUpdate(version updater.VersionInfo, canInstall bool) {
	if canInstall {
		f.qml.UpdateManualReady(version.Version.String())
	} else {
		f.qml.UpdateManualError()
	}
}

func (f *FrontendQt) SetVersion(version updater.VersionInfo) {
	f.newVersionInfo = version
	f.qml.SetReleaseNotesLink(version.ReleaseNotesPage)
	f.qml.SetLandingPageLink(version.LandingPage)
}

func (f *FrontendQt) NotifySilentUpdateInstalled() {
	f.qml.UpdateSilentRestartNeeded()
}

func (f *FrontendQt) NotifySilentUpdateError(err error) {
	f.log.WithError(err).Warn("Update failed, asking for manual.")
	f.qml.UpdateManualError()
}

func (f *FrontendQt) WaitUntilFrontendIsReady() {
	// TODO: Implement
}
