//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//
import QtQuick
import QtQuick.Layouts
import JASP.Controls
import JASP

Section
{
	property string testType:	"robust"

	title: 		qsTr("Plots")

	Group
	{
		title:	qsTr("Pooled estimates")
		columns: 1

		CheckBox
		{
			label:	qsTr("Effect")
			name:	"plotsPooledEstimatesEffect"
		}

		CheckBox
		{
			label:	qsTr("Unequal variances (precision allocation)")
			name:	"plotsPooledEstimatesUnequalVariances"
		}

		CheckBox
		{
			label:	qsTr("Outliers (degrees of freedom)")
			name:	"plotsPooledEstimatesOutliers"
			visible:testType === "robust"
		}

	}

	Group
	{
		title:		" " // Add a line to align with the first column
		columns:	1

		RadioButtonGroup
		{
			name:		"plotsPooledEstimatesType"
			title:		qsTr("Type")
			columns:	2

			RadioButton
			{
				value:		"averaged"
				label:		qsTr("Model averaged")
				checked:	true
			}

			RadioButton
			{
				value:		"conditional"
				label:		qsTr("Conditional")
			}

		}

		CheckBox
		{
			label:		qsTr("Prior distribution")
			name:		"plotsPooledEstimatesPriorDistribution"
			checked:	true
		}
	}

}
