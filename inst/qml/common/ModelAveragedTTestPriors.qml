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

ColumnLayout
{
	spacing: 						0
	property string componentType:	"Default type"

	Label
	{
		text:	switch (componentType)
		{
			case "modelsEffect":				qsTr("Effect"); break;
			case "modelsEffectNull":			qsTr("Effect (null)"); break;
			case "modelsUnequalVariances":		qsTr("Unequal variances (precision allocation)"); break;
			case "modelsUnequalVariancesNull":	qsTr("Unequal variances (null)"); break;
			case "modelsOutliers":				qsTr("Outliers (degrees of freedom + 2)"); break;
			case "modelsOutliersNull":			qsTr("Outliers (null)"); break;
			case "modelCommonMean":				qsTr("Common mean"); break;
			case "modelCommonVariance":			qsTr("Common variance"); break;
		}
		Layout.preferredHeight:	20 * preferencesModel.uiScale
	}

	RowLayout
	{
		Label { text: qsTr("Distribution"); Layout.preferredWidth: 140 * preferencesModel.uiScale; Layout.leftMargin: 5 * preferencesModel.uiScale}
		Label { text: qsTr("Parameters");	Layout.preferredWidth: 155 * preferencesModel.uiScale }
		Label { text: qsTr("Truncation");	Layout.preferredWidth: 150 * preferencesModel.uiScale }
		Label { text: qsTr("Prior weights") }
	}

	ComponentsList
	{
		name:					componentType
		optionKey:				"name"
		minimumItems:			componentType == "modelCommonMean" || componentType == "modelCommonVariance" ? 1 : 0
		maximumItems:			1
		//showAddIcon:			false
		defaultValues:			switch (componentType)
		{
			case "modelsEffect":				[{"type": "normal"}]; break;
			case "modelsEffectNull":			[{"type": "spike"}]; break;
			case "modelsUnequalVariances":		[{"type": "beta", "alpha": "1", "beta": "1"}]; break;
			case "modelsUnequalVariancesNull":	[{"type": "spike", "x0": "0.5"}]; break;
			case "modelsOutliers":				[{"type": "exponential", "lambda": "1"}]; break;
			case "modelsOutliersNull":			[{"type": "None"}]; break;
			case "modelCommonMean":				[{"type": "cauchy", "x0": "0", "theta": "1"}]; break;
			case "modelCommonVariance":			[{"type": "exponential", "lambda": "1"}]; break;
		}
		rowComponent: 			RowLayout
		{
			Row
			{
				spacing:				4 * preferencesModel.uiScale
				Layout.preferredWidth:	140 * preferencesModel.uiScale

				DropDown
				{
					id: typeItem
					name: "type"
					useExternalBorder: true
					values:
					[
						{ label: qsTr("Normal(μ,σ)"),			value: "normal"},
						{ label: qsTr("Student-t(μ,σ,v)"),		value: "t"},
						{ label: qsTr("Cauchy(x₀,θ)"),			value: "cauchy"},
						{ label: qsTr("Gamma(α,β)"),			value: "gammaAB"},
						{ label: qsTr("Gamma(k,θ)"),			value: "gammaK0"},
						{ label: qsTr("Inverse-Gamma(α,β)"),	value: "invgamma"},
						{ label: qsTr("Log-Normal(μ,σ)"),		value: "lognormal"},
						{ label: qsTr("Beta(α,β)"),				value: "beta"},
						{ label: qsTr("Uniform(a,b)"),			value: "uniform"},
						{ label: qsTr("Exponential(λ)"),		value: "exponential"},
						{ label: qsTr("Spike(x₀)"),				value: "spike"},
						{ label: qsTr("None"),					value: "none"}
					]
				}
			}

			Row
			{
				spacing:				4 * preferencesModel.uiScale
				Layout.preferredWidth:	155 * preferencesModel.uiScale

				FormulaField
				{
					label:				"μ "
					name:				"mu"
					visible:			typeItem.currentValue === "normal"		||
										typeItem.currentValue === "lognormal"	||
										typeItem.currentValue === "t"
					value:				"0"
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"x₀"
					name:				"x0"
					visible:			typeItem.currentValue === "cauchy"	||
										typeItem.currentValue === "spike"
					value:				if((componentType == "modelsUnequalVariances" || componentType == "modelsUnequalVariancesNull") && typeItem.currentValue === "spike")
											"0.5"
										else if((componentType == "modelsOutliers" || componentType == "modelsOutliersNull") && typeItem.currentValue === "spike")
											"Inf"
										else
											"0"
					inclusive:			if((componentType == "modelsOutliers" || componentType == "modelsOutliersNull") && typeItem.currentValue === "spike")
											JASP.MinMax
										else
											JASP.None
					min:				if((componentType == "modelsUnequalVariances" || componentType == "modelsUnequalVariancesNull" || componentType == "modelsOutliers" || componentType == "modelsOutliersNull") && typeItem.currentValue === "spike")
											0
										else
											"-Inf"
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"σ"
					name:				"sigma"
					id:					sigma
					visible:			typeItem.currentValue === "normal"		||
										typeItem.currentValue === "lognormal"	||
										typeItem.currentValue === "t"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"k "
					name:				"k"
					visible:			typeItem.currentValue === "gammaK0"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
				}
				FormulaField
				{
					label:				"θ"
					name:				"theta"
					visible:			typeItem.currentValue === "cauchy"	||
										typeItem.currentValue === "gammaK0"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"ν"
					name:				"nu"
					visible:			typeItem.currentValue === "t"
					value:				"2"
					min:				1
					inclusive:			JASP.MinOnly
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"α "
					name:				"alpha"
					visible:			typeItem.currentValue === "gammaAB"	 ||
										typeItem.currentValue === "invgamma" ||
										typeItem.currentValue === "beta"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"β"
					name:				"beta"
					visible:			typeItem.currentValue === "gammaAB"	 ||
										typeItem.currentValue === "invgamma" ||
										typeItem.currentValue === "beta"
					value:				"0.15"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"a "
					name:				"a"
					id:					a
					visible:			typeItem.currentValue === "uniform"
					value:				"0"
					max:				b.value
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"b"
					name:				"b"
					id:					b
					visible:			typeItem.currentValue === "uniform"
					value:				"1"
					min:				a.value
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
				FormulaField
				{
					label:				"λ"
					name:				"lambda"
					visible:			typeItem.currentValue === "exponential"
					value:				"1"
					min:				0
					inclusive:			JASP.None
					fieldWidth: 		40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder: 		true
				}
			}

			Row
			{
				spacing:				4 * preferencesModel.uiScale
				Layout.preferredWidth:	150 * preferencesModel.uiScale

				FormulaField
				{
					id:					truncationLower
					label: 				qsTr("lower")
					name: 				"truncationLower"
					visible:			typeItem.currentValue !== "spike" && typeItem.currentValue !== "uniform" && typeItem.currentValue !== "none"
					value:
					{
						if(componentType == "modelsUnequalVariances" || componentType == "modelsUnequalVariancesNull" || componentType == "modelsOutliers" || componentType == "modelsOutliersNull")
							0
						else if (typeItem.currentValue === "gammaK0" || typeItem.currentValue === "gammaAB" || typeItem.currentValue === "invgamma" || typeItem.currentValue === "lognormal" || typeItem.currentValue === "beta" || typeItem.currentValue === "exponential")
							0
						else
							"-Inf"
					}
					min:
					{
						if(componentType == "modelsUnequalVariances" || componentType == "modelsUnequalVariancesNull" || componentType == "modelsOutliers" || componentType == "modelsOutliersNull")
							0
						else if (typeItem.currentValue === "gammaK0" || typeItem.currentValue === "gammaAB" || typeItem.currentValue === "invgamma" || typeItem.currentValue === "lognormal" || typeItem.currentValue === "beta" || typeItem.currentValue === "exponential")
							0
						else
							"-Inf"
					}
					max: 				truncationUpper.value
					inclusive: 			JASP.MinOnly
					fieldWidth:			40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder:			true
				}
				FormulaField
				{
					id:					truncationUpper
					label: 				qsTr("upper")
					name: 				"truncationUpper"
					visible:			typeItem.currentValue !== "spike" && typeItem.currentValue !== "uniform" && typeItem.currentValue !== "none"
					value:
					{
						if (typeItem.currentValue === "beta")
							1
						else
							"Inf"
					}
					max:
					{
						if (typeItem.currentValue === "beta")
							1
						else
							"Inf"
					}
					min: 				truncationLower ? truncationLower.value : 0
					inclusive: 			JASP.MaxOnly
					fieldWidth:			40 * preferencesModel.uiScale
					useExternalBorder:	false
					showBorder:			true
				}
			}

			FormulaField
			{
				label: 				qsTr("Weight")
				name: 				"priorWeight"
				value:				"1"
				min: 				0
				inclusive: 			JASP.None
				fieldWidth:			40 * preferencesModel.uiScale
				useExternalBorder:	false
				showBorder:			true
			}
		}
	}
}
