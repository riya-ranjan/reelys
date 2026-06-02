{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 9,
			"minor" : 1,
			"revision" : 4,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 59.0, 80.0, 1040.0, 740.0 ],
		"boxes" : [
			{
				"box" : 				{
					"id" : "obj-doc",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"fontsize" : 12.0,
					"linecount" : 6,
					"patching_rect" : [ 20.0, 6.0, 1000.0, 95.0 ],
					"text" : "wee_oo_duet.maxpat — Reelys Step 4 (variant): the two shoes as TWO SEPARATE instruments, each driven only by its own foot, hard-panned to its side.\nLEFT instrument = smooth detuned-triangle lead (mid register), hard left.   RIGHT instrument = soft sine pad (low register), hard right.\nPer foot:  az (lean) -> note pitch + volume gate (silent below per-foot threshold: L~48, R~79; az bands L 38->67, R 70->95) ;   ax (fore/aft tilt) -> filter brightness (lores~) ;   ay (lateral) -> wee-oo LFO rate.\nMIDI: CC1=ax, CC2=ay, CC3=az.  ch1 = Left, ch2 = Right.  Enable both BLE MIDI sources in Options > MIDI Setup, then click ezdac~.\nNo cross-shoe math, so each voice is independent (the hot/cold bug can't happen here). All ranges live in the scale objects — tune per foot while wheeling.\nNote: ax baselines differ per foot (left ~54, right ~66), so the two cutoff scales use different input ranges on purpose."
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-lblL",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"fontsize" : 13.0,
					"patching_rect" : [ 40.0, 118.0, 320.0, 20.0 ],
					"text" : "LEFT INSTRUMENT — triangle lead (hard left)"
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-lblR",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"fontsize" : 13.0,
					"patching_rect" : [ 560.0, 118.0, 340.0, 20.0 ],
					"text" : "RIGHT INSTRUMENT — sine pad (hard right)"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-ax",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 40.0, 150.0, 58.0, 22.0 ],
					"text" : "ctlin 1 1"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-ay",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 130.0, 150.0, 58.0, 22.0 ],
					"text" : "ctlin 2 1"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-az",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 220.0, 150.0, 58.0, 22.0 ],
					"text" : "ctlin 3 1"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-axs",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 40.0, 186.0, 58.0, 22.0 ],
					"text" : "slide 8 8"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-ays",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 130.0, 186.0, 58.0, 22.0 ],
					"text" : "slide 8 8"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-azs",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 220.0, 186.0, 58.0, 22.0 ],
					"text" : "slide 8 8"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-cut",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 40.0, 230.0, 150.0, 22.0 ],
					"text" : "scale 48. 62. 300. 2200."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-cutc",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 40.0, 264.0, 110.0, 22.0 ],
					"text" : "clip 200. 6000."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-rate",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 200.0, 230.0, 120.0, 22.0 ],
					"text" : "scale 0. 8. 0.5 3."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-ratec",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 200.0, 264.0, 80.0, 22.0 ],
					"text" : "clip 0.5 8."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-pit",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 330.0, 230.0, 150.0, 22.0 ],
					"text" : "scale 40. 64. 55. 76."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-mtof",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 330.0, 264.0, 50.0, 22.0 ],
					"text" : "mtof"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-vol",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 330.0, 320.0, 130.0, 22.0 ],
					"text" : "scale 46. 60. 0. 1."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-volc",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 330.0, 354.0, 70.0, 22.0 ],
					"text" : "clip 0. 1."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-base",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 330.0, 300.0, 50.0, 22.0 ],
					"text" : "sig~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-vols",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 330.0, 388.0, 50.0, 22.0 ],
					"text" : "sig~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-lfo",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 200.0, 300.0, 60.0, 22.0 ],
					"text" : "cycle~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-swp",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 200.0, 336.0, 60.0, 22.0 ],
					"text" : "*~ 6."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-add",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 200.0, 372.0, 80.0, 22.0 ],
					"text" : "+~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-cf",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 200.0, 408.0, 110.0, 22.0 ],
					"text" : "clip~ 20. 6000."
				}

			}
,
			{
				"box" : 				{
					"id" : "L-det",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 120.0, 444.0, 70.0, 22.0 ],
					"text" : "*~ 1.01"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-saw1",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 40.0, 480.0, 50.0, 22.0 ],
					"text" : "tri~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-saw2",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 120.0, 480.0, 50.0, 22.0 ],
					"text" : "tri~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-sum",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 40.0, 516.0, 60.0, 22.0 ],
					"text" : "+~"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-scl",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 40.0, 552.0, 60.0, 22.0 ],
					"text" : "*~ 0.6"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-filt",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 40.0, 588.0, 110.0, 22.0 ],
					"text" : "lores~ 1800 0.2"
				}

			}
,
			{
				"box" : 				{
					"id" : "L-amp",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 40.0, 624.0, 80.0, 22.0 ],
					"text" : "*~"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-ax",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 560.0, 150.0, 58.0, 22.0 ],
					"text" : "ctlin 1 2"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-ay",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 650.0, 150.0, 58.0, 22.0 ],
					"text" : "ctlin 2 2"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-az",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 740.0, 150.0, 58.0, 22.0 ],
					"text" : "ctlin 3 2"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-axs",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 560.0, 186.0, 58.0, 22.0 ],
					"text" : "slide 8 8"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-ays",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 650.0, 186.0, 58.0, 22.0 ],
					"text" : "slide 8 8"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-azs",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 740.0, 186.0, 58.0, 22.0 ],
					"text" : "slide 8 8"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-cut",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 560.0, 230.0, 150.0, 22.0 ],
					"text" : "scale 58. 72. 400. 2500."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-cutc",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 560.0, 264.0, 110.0, 22.0 ],
					"text" : "clip 200. 6000."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-rate",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 720.0, 230.0, 120.0, 22.0 ],
					"text" : "scale 0. 8. 0.5 3."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-ratec",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 720.0, 264.0, 80.0, 22.0 ],
					"text" : "clip 0.5 8."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-pit",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 850.0, 230.0, 150.0, 22.0 ],
					"text" : "scale 62. 90. 36. 60."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-mtof",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 850.0, 264.0, 50.0, 22.0 ],
					"text" : "mtof"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-vol",
					"maxclass" : "newobj",
					"numinlets" : 6,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 850.0, 320.0, 130.0, 22.0 ],
					"text" : "scale 70. 86. 0. 1."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-volc",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "float" ],
					"patching_rect" : [ 850.0, 354.0, 70.0, 22.0 ],
					"text" : "clip 0. 1."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-base",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 850.0, 300.0, 50.0, 22.0 ],
					"text" : "sig~"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-vols",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 850.0, 388.0, 50.0, 22.0 ],
					"text" : "sig~"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-lfo",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 720.0, 300.0, 60.0, 22.0 ],
					"text" : "cycle~"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-swp",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 720.0, 336.0, 60.0, 22.0 ],
					"text" : "*~ 5."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-add",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 720.0, 372.0, 80.0, 22.0 ],
					"text" : "+~"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-cf",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 720.0, 408.0, 110.0, 22.0 ],
					"text" : "clip~ 20. 6000."
				}

			}
,
			{
				"box" : 				{
					"id" : "R-sq",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 560.0, 480.0, 50.0, 22.0 ],
					"text" : "cycle~"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-scl",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 560.0, 516.0, 60.0, 22.0 ],
					"text" : "*~ 0.32"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-filt",
					"maxclass" : "newobj",
					"numinlets" : 3,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 560.0, 552.0, 110.0, 22.0 ],
					"text" : "lores~ 2000 0.2"
				}

			}
,
			{
				"box" : 				{
					"id" : "R-amp",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 560.0, 588.0, 80.0, 22.0 ],
					"text" : "*~"
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-dac",
					"maxclass" : "ezdac~",
					"numinlets" : 2,
					"numoutlets" : 0,
					"patching_rect" : [ 330.0, 660.0, 45.0, 45.0 ]
				}

			}
,
			{
				"box" : 				{
					"id" : "obj-lbldac",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 385.0, 672.0, 320.0, 18.0 ],
					"text" : "click to start audio  (L instrument -> left, R -> right)"
				}

			}
		],
		"lines" : [
			{ "patchline" : { "source" : [ "L-ax", 0 ], "destination" : [ "L-axs", 0 ] } },
			{ "patchline" : { "source" : [ "L-ay", 0 ], "destination" : [ "L-ays", 0 ] } },
			{ "patchline" : { "source" : [ "L-az", 0 ], "destination" : [ "L-azs", 0 ] } },
			{ "patchline" : { "source" : [ "L-axs", 0 ], "destination" : [ "L-cut", 0 ] } },
			{ "patchline" : { "source" : [ "L-cut", 0 ], "destination" : [ "L-cutc", 0 ] } },
			{ "patchline" : { "source" : [ "L-ays", 0 ], "destination" : [ "L-rate", 0 ] } },
			{ "patchline" : { "source" : [ "L-rate", 0 ], "destination" : [ "L-ratec", 0 ] } },
			{ "patchline" : { "source" : [ "L-azs", 0 ], "destination" : [ "L-pit", 0 ] } },
			{ "patchline" : { "source" : [ "L-azs", 0 ], "destination" : [ "L-vol", 0 ] } },
			{ "patchline" : { "source" : [ "L-pit", 0 ], "destination" : [ "L-mtof", 0 ] } },
			{ "patchline" : { "source" : [ "L-mtof", 0 ], "destination" : [ "L-base", 0 ] } },
			{ "patchline" : { "source" : [ "L-vol", 0 ], "destination" : [ "L-volc", 0 ] } },
			{ "patchline" : { "source" : [ "L-volc", 0 ], "destination" : [ "L-vols", 0 ] } },
			{ "patchline" : { "source" : [ "L-ratec", 0 ], "destination" : [ "L-lfo", 0 ] } },
			{ "patchline" : { "source" : [ "L-lfo", 0 ], "destination" : [ "L-swp", 0 ] } },
			{ "patchline" : { "source" : [ "L-swp", 0 ], "destination" : [ "L-add", 0 ] } },
			{ "patchline" : { "source" : [ "L-base", 0 ], "destination" : [ "L-add", 1 ] } },
			{ "patchline" : { "source" : [ "L-add", 0 ], "destination" : [ "L-cf", 0 ] } },
			{ "patchline" : { "source" : [ "L-cf", 0 ], "destination" : [ "L-saw1", 0 ] } },
			{ "patchline" : { "source" : [ "L-cf", 0 ], "destination" : [ "L-det", 0 ] } },
			{ "patchline" : { "source" : [ "L-det", 0 ], "destination" : [ "L-saw2", 0 ] } },
			{ "patchline" : { "source" : [ "L-saw1", 0 ], "destination" : [ "L-sum", 0 ] } },
			{ "patchline" : { "source" : [ "L-saw2", 0 ], "destination" : [ "L-sum", 1 ] } },
			{ "patchline" : { "source" : [ "L-sum", 0 ], "destination" : [ "L-scl", 0 ] } },
			{ "patchline" : { "source" : [ "L-scl", 0 ], "destination" : [ "L-filt", 0 ] } },
			{ "patchline" : { "source" : [ "L-cutc", 0 ], "destination" : [ "L-filt", 1 ] } },
			{ "patchline" : { "source" : [ "L-filt", 0 ], "destination" : [ "L-amp", 0 ] } },
			{ "patchline" : { "source" : [ "L-vols", 0 ], "destination" : [ "L-amp", 1 ] } },
			{ "patchline" : { "source" : [ "L-amp", 0 ], "destination" : [ "obj-dac", 0 ] } },
			{ "patchline" : { "source" : [ "R-ax", 0 ], "destination" : [ "R-axs", 0 ] } },
			{ "patchline" : { "source" : [ "R-ay", 0 ], "destination" : [ "R-ays", 0 ] } },
			{ "patchline" : { "source" : [ "R-az", 0 ], "destination" : [ "R-azs", 0 ] } },
			{ "patchline" : { "source" : [ "R-axs", 0 ], "destination" : [ "R-cut", 0 ] } },
			{ "patchline" : { "source" : [ "R-cut", 0 ], "destination" : [ "R-cutc", 0 ] } },
			{ "patchline" : { "source" : [ "R-ays", 0 ], "destination" : [ "R-rate", 0 ] } },
			{ "patchline" : { "source" : [ "R-rate", 0 ], "destination" : [ "R-ratec", 0 ] } },
			{ "patchline" : { "source" : [ "R-azs", 0 ], "destination" : [ "R-pit", 0 ] } },
			{ "patchline" : { "source" : [ "R-azs", 0 ], "destination" : [ "R-vol", 0 ] } },
			{ "patchline" : { "source" : [ "R-pit", 0 ], "destination" : [ "R-mtof", 0 ] } },
			{ "patchline" : { "source" : [ "R-mtof", 0 ], "destination" : [ "R-base", 0 ] } },
			{ "patchline" : { "source" : [ "R-vol", 0 ], "destination" : [ "R-volc", 0 ] } },
			{ "patchline" : { "source" : [ "R-volc", 0 ], "destination" : [ "R-vols", 0 ] } },
			{ "patchline" : { "source" : [ "R-ratec", 0 ], "destination" : [ "R-lfo", 0 ] } },
			{ "patchline" : { "source" : [ "R-lfo", 0 ], "destination" : [ "R-swp", 0 ] } },
			{ "patchline" : { "source" : [ "R-swp", 0 ], "destination" : [ "R-add", 0 ] } },
			{ "patchline" : { "source" : [ "R-base", 0 ], "destination" : [ "R-add", 1 ] } },
			{ "patchline" : { "source" : [ "R-add", 0 ], "destination" : [ "R-cf", 0 ] } },
			{ "patchline" : { "source" : [ "R-cf", 0 ], "destination" : [ "R-sq", 0 ] } },
			{ "patchline" : { "source" : [ "R-sq", 0 ], "destination" : [ "R-scl", 0 ] } },
			{ "patchline" : { "source" : [ "R-scl", 0 ], "destination" : [ "R-filt", 0 ] } },
			{ "patchline" : { "source" : [ "R-cutc", 0 ], "destination" : [ "R-filt", 1 ] } },
			{ "patchline" : { "source" : [ "R-filt", 0 ], "destination" : [ "R-amp", 0 ] } },
			{ "patchline" : { "source" : [ "R-vols", 0 ], "destination" : [ "R-amp", 1 ] } },
			{ "patchline" : { "source" : [ "R-amp", 0 ], "destination" : [ "obj-dac", 1 ] } }
		],
		"autosave" : 0,
		"oscreceiveudpport" : 0
	}

}
