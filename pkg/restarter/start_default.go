// Copyright (c) 2025 Proton AG
//
// This file is part of Proton Mail Bridge.
//
// Proton Mail Bridge is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Proton Mail Bridge is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Proton Mail Bridge.  If not, see <https://www.gnu.org/licenses/>.

//go:build !windows
// +build !windows

package restarter

import (
	"os/exec"
	"syscall"

	"github.com/sirupsen/logrus"
)

func run(cmd *exec.Cmd) error {
	// Provide a new Group ID to the new process to ensure the child is detached even if parent crash before ending.
	cmd.SysProcAttr = &syscall.SysProcAttr{
		Setpgid: true,
		Pgid:    0,
	}

	logrus.WithField("cmd", cmd).Info("Starting new process")

	return cmd.Start()
}
