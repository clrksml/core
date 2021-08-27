local AC = {}

AC._G = table.Copy(_G)

AC.netaddress = AC._G.GetGlobalString("ac_netaddress")

AC.Sent = {}
AC.Binds = {}
AC.Hooks = {}
AC.Convars = { ["sv_allowcslua"] = 0, ["sv_cheats"] = 0, ["mat_wireframe"] = 0, ["host_timescale"] = 1, ["r_drawothermodels"] = 1, ["net_blockmsg"] = "none", ["incrementvar"] = "" }
AC.Strings = { "aim", "aimbot", "bhop", "bunny", "cham", "cheat", "esp", "hack", "hax", "norecoil", "recoil", "speedhack", "scripthook", "target", "traitor", "toggle", "trigger", "xray", "wallhack" }
AC.DFiles = { ['lua/includes/util/model_database.lua'] = '1418398381', ['lua/autorun/properties/skin.lua'] = '3359722692', ['lua/postprocess/motion_blur.lua'] = '958232994', ['lua/includes/dev_server_test.lua'] = '3256203588', ['lua/menu/menu_demo.lua'] = '1076045330', ['lua/autorun/properties/gravity.lua'] = '3419315665', ['lua/vgui/dsizetocontents.lua'] = '1734220072', ['lua/includes/extensions/entity.lua'] = '2428608366', ['lua/menu/menu_addon.lua'] = '1626927591', ['lua/vgui/fingerposer.lua'] = '3808270647', ['lua/vgui/dtextentry.lua'] = '1618532179', ['lua/autorun/server/sv_fonts.lua'] = '2513657764', ['lua/vgui/contextbase.lua'] = '2257171883', ['lua/autorun/base_vehicles.lua'] = '835761676', ['lua/includes/extensions/client/globals.lua'] = '1873902430', ['lua/vgui/dlistview_line.lua'] = '1237663058', ['lua/includes/gmsave/player.lua'] = '2003872251', ['lua/vgui/dmenubar.lua'] = '2814060501', ['lua/menu/getmaps.lua'] = '537367110', ['lua/derma/derma_utils.lua'] = '738455399', ['lua/includes/util/workshop_files.lua'] = '2437829078', ['lua/includes/gmsave/physics.lua'] = '4031702760', ['lua/includes/extensions/net.lua'] = '2678937381', ['lua/autorun/server/sensorbones/tf2_heavy.lua'] = '3878453846', ['lua/drive/drive_sandbox.lua'] = '332239717', ['lua/vgui/prop_boolean.lua'] = '1872958800', ['lua/postprocess/sobel.lua'] = '3805304761', ['lua/includes/modules/notification.lua'] = '4192016713', ['lua/postprocess/sunbeams.lua'] = '2344441110', ['lua/derma/derma_example.lua'] = '1584752360', ['lua/includes/modules/ai_schedule.lua'] = '1449467682', ['lua/includes/extensions/client/panel.lua'] = '1120325432', ['lua/entities/widget_arrow.lua'] = '4048962694', ['lua/autorun/properties.lua'] = '2199045731', ['lua/vgui/dmenu.lua'] = '2461464971', ['lua/matproxy/sky_paint.lua'] = '2689716763', ['lua/vgui/dcategorycollapse.lua'] = '375022891', ['lua/postprocess/bokeh_dof.lua'] = '38034597', ['lua/vgui/dadjustablemodelpanel.lua'] = '4232405841', ['lua/weapons/weapon_medkit.lua'] = '1829991880', ['lua/includes/extensions/client/player.lua'] = '850321911', ['lua/vgui/dshape.lua'] = '1046093930', ['lua/vgui/slidebar.lua'] = '399879504', ['lua/entities/widget_axis.lua'] = '3493383870', ['lua/vgui/dcategorylist.lua'] = '1610780774', ['lua/vgui/dtooltip.lua'] = '481647872', ['lua/autorun/server/sensorbones/tf2_pyro_demo.lua'] = '2785406760', ['lua/autorun/properties/statue.lua'] = '4056138698', ['lua/menu/errors.lua'] = '2839998823', ['lua/drive/drive_noclip.lua'] = '2770278410', ['lua/vgui/dbubblecontainer.lua'] = '1574783418', ['lua/includes/modules/http.lua'] = '3295821380', ['lua/vgui/dalphabar.lua'] = '1355517884', ['lua/postprocess/frame_blend.lua'] = '532030219', ['lua/vgui/dlistlayout.lua'] = '2112205809', ['lua/includes/extensions/player_auth.lua'] = '1243159482', ['lua/autorun/server/sensorbones/tf2_engineer.lua'] = '2583584187', ['lua/postprocess/color_modify.lua'] = '1635848671', ['lua/vgui/dimagebutton.lua'] = '2171930986', ['lua/vgui/dcolormixer.lua'] = '3669398', ['lua/includes/modules/player_manager.lua'] = '735663667', ['lua/postprocess/stereoscopy.lua'] = '3606154466', ['lua/vgui/dpaneloverlay.lua'] = '3673841780', ['lua/vgui/dscrollpanel.lua'] = '2465244497', ['lua/weapons/weapon_fists.lua'] = '2431072541', ['lua/includes/util/tooltips.lua'] = '1064467149', ['lua/vgui/dgrid.lua'] = '3430830342', ['lua/vgui/dmodelselect.lua'] = '30161942', ['lua/vgui/dnumslider.lua'] = '2483916952', ['lua/vgui/material.lua'] = '1581780309', ['lua/vgui/dmodelselectmulti.lua'] = '254644179', ['lua/vgui/dexpandbutton.lua'] = '1082155871', ['lua/derma/init.lua'] = '1765090406', ['lua/vgui/dentityproperties.lua'] = '391985512', ['lua/includes/extensions/client/panel/animation.lua'] = '1349090049', ['lua/vgui/dmodelpanel.lua'] = '3995527405', ['lua/menu/mount/vgui/addon_rocket.lua'] = '250050545', ['lua/includes/modules/scripted_ents.lua'] = '731818786', ['lua/vgui/dtilelayout.lua'] = '1837787652', ['lua/menu/progressbar.lua'] = '4173035803', ['lua/autorun/server/sensorbones/tf2_spy_solider.lua'] = '1884946784', ['lua/includes/gui/icon_progress.lua'] = '942682572', ['lua/includes/gmsave/entity_filters.lua'] = '3335087934', ['lua/vgui/dlistbox.lua'] = '3094517235', ['lua/derma/derma_animation.lua'] = '1626662651', ['lua/vgui/dverticaldivider.lua'] = '1174006168', ['lua/vgui/dtree_node_button.lua'] = '3383352139', ['lua/vgui/dtree.lua'] = '2546969600', ['lua/includes/extensions/debug.lua'] = '4223070679', ['lua/autorun/properties/kinect_controller.lua'] = '1719817855', ['lua/includes/extensions/util/worldpicker.lua'] = '1433107412', ['lua/includes/modules/spawnmenu.lua'] = '2558702150', ['lua/vgui/ddrawer.lua'] = '1373128586', ['lua/vgui/dnotify.lua'] = '1289307146', ['lua/includes/gmsave/constraints.lua'] = '433741718', ['lua/includes/extensions/ents.lua'] = '1753104975', ['lua/autorun/properties/bone_manipulate.lua'] = '3091250509', ['lua/vgui/dmenuoptioncvar.lua'] = '1857077969', ['lua/vgui/drgbpicker.lua'] = '2001990561', ['lua/autorun/utilities_menu.lua'] = '3344175820', ['lua/autorun/server/sensorbones/valvebiped.lua'] = '3535042990', ['lua/autorun/client/demo_recording.lua'] = '1643433772', ['lua/vgui/dtree_node.lua'] = '102754895', ['lua/vgui/dfilebrowser.lua'] = '1456960914', ['lua/includes/modules/concommand.lua'] = '3212901814', ['lua/vgui/dform.lua'] = '913061498', ['lua/vgui/diconbrowser.lua'] = '989298800', ['lua/vgui/diconlayout.lua'] = '63984191', ['lua/vgui/dbinder.lua'] = '2206001139', ['lua/autorun/playermodel.lua'] = '1727730762', ['lua/vgui/dpanelselect.lua'] = '2706339645', ['lua/vgui/dpanellist.lua'] = '1542869623', ['lua/menu/mount/mount.lua'] = '3667839923', ['lua/vgui/dcolorpalette.lua'] = '1800043030', ['lua/skins/cleanwhite.lua'] = '1446317264', ['lua/autorun/server/admin_functions.lua'] = '2738973524', ['lua/includes/vgui_base.lua'] = '3247615573', ['lua/autorun/game_hl2.lua'] = '2534272786', ['lua/menu/motionsensor.lua'] = '2961739243', ['lua/includes/util/color.lua'] = '2948482556', ['lua/vgui/dscrollbargrip.lua'] = '3125629053', ['lua/vgui/dcolumnsheet.lua'] = '2303951061', ['lua/vgui/dkillicon.lua'] = '4063647933', ['lua/includes/modules/markup.lua'] = '2546259512', ['lua/includes/init.lua'] = '2593529421', ['lua/vgui/dsprite.lua'] = '2777678394', ['lua/weapons/weapon_flechettegun.lua'] = '981325598', ['lua/includes/extensions/util.lua'] = '1473364429', ['lua/includes/extensions/client/render.lua'] = '3580886587', ['lua/vgui/spawnicon.lua'] = '1294117418', ['lua/vgui/propselect.lua'] = '4034160801', ['lua/vgui/prop_vectorcolor.lua'] = '3237432986', ['lua/autorun/server/sensorbones/tf2_scout.lua'] = '1541660142', ['lua/vgui/prop_generic.lua'] = '2830525596', ['lua/includes/modules/drive.lua'] = '905225197', ['lua/vgui/matselect.lua'] = '3496749737', ['lua/includes/modules/undo.lua'] = '3551046500', ['lua/derma/derma.lua'] = '1352734684', ['lua/vgui/dlistview_column.lua'] = '3708470747', ['lua/includes/modules/team.lua'] = '3149315038', ['lua/includes/modules/search.lua'] = '4036825565', ['lua/autorun/properties/keep_upright.lua'] = '3048968084', ['lua/vgui/dnumberwang.lua'] = '100713156', ['lua/includes/modules/saverestore.lua'] = '1042687843', ['lua/includes/modules/presets.lua'] = '2440695555', ['lua/includes/modules/numpad.lua'] = '603057233', ['lua/vgui/dlabel.lua'] = '1743771420', ['lua/menu/mount/vgui/workshop.lua'] = '2465954788', ['lua/vgui/dslider.lua'] = '838243570', ['lua/vgui/dpanel.lua'] = '2192179779', ['lua/includes/modules/menubar.lua'] = '3588586039', ['lua/includes/extensions/client/panel/scriptedpanels.lua'] = '1258843005', ['lua/includes/modules/list.lua'] = '1499775861', ['lua/vgui/dlabelurl.lua'] = '2981350768', ['lua/menu/demo_to_video.lua'] = '2272933442', ['lua/vgui/fingervar.lua'] = '2964862237', ['lua/includes/modules/hook.lua'] = '216388794', ['lua/includes/util/vgui_showlayout.lua'] = '1573123655', ['lua/vgui/dproperties.lua'] = '2760782058', ['lua/vgui/dprogress.lua'] = '1219558433', ['lua/includes/modules/gamemode.lua'] = '3592824555', ['lua/includes/modules/draw.lua'] = '3498361362', ['lua/includes/modules/cvars.lua'] = '4092793187', ['lua/autorun/properties/bodygroups.lua'] = '571450387', ['lua/vgui/dlabeleditable.lua'] = '716145027', ['lua/includes/modules/construct.lua'] = '2448409831', ['lua/includes/init_menu.lua'] = '2640103972', ['lua/includes/extensions/math.lua'] = '3545912801', ['lua/vgui/dcheckbox.lua'] = '2814585320', ['lua/autorun/server/sensorbones/tf2_sniper.lua'] = '3868604690', ['lua/menu/menu.lua'] = '2254508838', ['lua/vgui/dmenuoption.lua'] = '2070196338', ['lua/autorun/server/sensorbones/css.lua'] = '1735860339', ['lua/includes/extensions/vector.lua'] = '2984259392', ['lua/postprocess/dof.lua'] = '1683476943', ['lua/includes/modules/controlpanel.lua'] = '2599350609', ['lua/skins/default.lua'] = '998710010', ['lua/includes/modules/weapons.lua'] = '1541259980', ['lua/entities/sent_ball.lua'] = '1203551105', ['lua/autorun/properties/editentity.lua'] = '1478978589', ['lua/includes/extensions/player.lua'] = '2789042996', ['lua/menu/menu_save.lua'] = '718813323', ['lua/includes/extensions/file.lua'] = '2464932372', ['lua/vgui/prop_float.lua'] = '139387589', ['lua/includes/extensions/game.lua'] = '2521622218', ['lua/includes/extensions/coroutine.lua'] = '3229828844', ['lua/includes/modules/ai_task.lua'] = '224465559', ['lua/vgui/dcolorcombo.lua'] = '4169566267', ['lua/derma/derma_menus.lua'] = '433616383', ['lua/includes/extensions/angle.lua'] = '2691644848', ['lua/includes/extensions/client/panel/selections.lua'] = '265837601', ['lua/vgui/ddragbase.lua'] = '2535804955', ['lua/includes/extensions/client/entity.lua'] = '1245913801', ['lua/vgui/dpropertysheet.lua'] = '4192946015', ['lua/entities/widget_disc.lua'] = '459016461', ['lua/autorun/properties/ignite.lua'] = '1601014494', ['lua/vgui/dnumpad.lua'] = '2685472684', ['lua/includes/modules/matproxy.lua'] = '2314817673', ['lua/includes/gmsave.lua'] = '902421830', ['lua/autorun/properties/collisions.lua'] = '1643263752', ['lua/vgui/dimage.lua'] = '959263021', ['lua/autorun/menubar.lua'] = '2171318939', ['lua/vgui/dcolorbutton.lua'] = '2481074427', ['lua/vgui/imagecheckbox.lua'] = '3375001807', ['lua/vgui/dcolorcube.lua'] = '722733505', ['lua/includes/extensions/table.lua'] = '3730045919', ['lua/autorun/properties/remove.lua'] = '1546537784', ['lua/vgui/vgui_panellist.lua'] = '677166680', ['lua/includes/modules/effects.lua'] = '3730253312', ['lua/autorun/properties/persist.lua'] = '3658573861', ['lua/drive/drive_base.lua'] = '297095468', ['lua/autorun/client/gm_demo.lua'] = '3293367516', ['lua/includes/modules/killicon.lua'] = '2016475777', ['lua/autorun/client/cl_fonts.lua'] = '3017986136', ['lua/autorun/base_npcs.lua'] = '2037752297', ['lua/entities/widget_base.lua'] = '4140587996', ['lua/entities/widget_bones.lua'] = '4240256591', ['lua/vgui/dframe.lua'] = '625455276', ['lua/vgui/prop_int.lua'] = '3826574141', ['lua/vgui/dnumberscratch.lua'] = '1279436911', ['lua/vgui/prop_combo.lua'] = '4126783563', ['lua/vgui/dlistview.lua'] = '2434953979', ['lua/includes/menu.lua'] = '2859767422', ['lua/includes/util.lua'] = '3095130359', ['lua/matproxy/player_weapon_color.lua'] = '2786938810', ['lua/menu/background.lua'] = '259697530', ['lua/includes/extensions/string.lua'] = '369697349', ['lua/menu/menu_dupe.lua'] = '2327500843', ['lua/autorun/properties/npc_scale.lua'] = '3084496971', ['lua/menu/video.lua'] = '3895367197', ['lua/postprocess/bloom.lua'] = '3617801188', ['lua/menu/loading.lua'] = '3407248972', ['lua/includes/modules/cleanup.lua'] = '2527305308', ['lua/postprocess/overlay.lua'] = '361445622', ['lua/vgui/dcombobox.lua'] = '2504218077', ['lua/postprocess/sharpen.lua'] = '97905879', ['lua/postprocess/super_dof.lua'] = '3201847442', ['lua/autorun/server/sensorbones/eli.lua'] = '2158593446', ['lua/postprocess/texturize.lua'] = '3391893584', ['lua/vgui/dhtmlcontrols.lua'] = '2097240656', ['lua/includes/util/javascript_util.lua'] = '2065162580', ['lua/vgui/dhorizontaldivider.lua'] = '4115875682', ['lua/autorun/developer_functions.lua'] = '2880117786', ['lua/includes/modules/constraint.lua'] = '3925952080', ['lua/autorun/properties/drive.lua'] = '2213625409', ['lua/includes/modules/halo.lua'] = '266158263', ['lua/includes/modules/cookie.lua'] = '537551951', ['lua/autorun/server/sensorbones/tf2_medic.lua'] = '2044886853', ['lua/vgui/dvscrollbar.lua'] = '2602976655', ['lua/menu/mainmenu.lua'] = '1652054869', ['lua/vgui/dhorizontalscroller.lua'] = '960529765', ['lua/includes/modules/widget.lua'] = '2192150882', ['lua/includes/extensions/client/panel/dragdrop.lua'] = '2615895619', ['lua/vgui/dhtml.lua'] = '469674499', ['lua/includes/modules/baseclass.lua'] = '960891872', ['lua/includes/util/sql.lua'] = '3403545121', ['lua/includes/extensions/motionsensor.lua'] = '1465704471', ['lua/includes/modules/usermessage.lua'] = '7247932', ['lua/matproxy/player_color.lua'] = '2273936060', ['lua/weapons/gmod_tool/stools/tttweaponplacer.lua'] = '2398954900', ['lua/includes/modules/duplicator.lua'] = '3964218977', ['lua/derma/derma_gwen.lua'] = '1239487251', ['lua/vgui/dbutton.lua'] = '3626203882', ['lua/includes/modules/properties.lua'] = '567235612', ['lua/includes/extensions/weapon.lua'] = '1318584369', ['lua/includes/util/client.lua'] = '3105646206', ['lua/postprocess/toytown.lua'] = '1759156311', }
AC.Debug = {['cam'] = {['PushModelMatrix'] = { src = '=[C]', func = 'function: 0x15ca41a8' },['Start3D'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x20608950' },['End3D'] = { src = '=[C]', func = 'function: 0x15ca3fa0' },['Start3D2D'] = { src = '=[C]', func = 'function: 0x15ca4128' },['End2D'] = { src = '=[C]', func = 'function: 0x15ca4018' },['StartOrthoView'] = { src = '=[C]', func = 'function: 0x15ca4058' },['End3D2D'] = { src = '=[C]', func = 'function: 0x15ca4168' },['Start'] = { src = '=[C]', func = 'function: 0x15ca3f48' },['IgnoreZ'] = { src = '=[C]', func = 'function: 0x15ca40e8' },['Start2D'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x20608938' },['End'] = { src = '=[C]', func = 'function: 0x15ca3fe0' },['EndOrthoView'] = { src = '=[C]', func = 'function: 0x15ca40a0' },['ApplyShake'] = { src = '=[C]', func = 'function: 0x15ca4238' },['PopModelMatrix'] = { src = '=[C]', func = 'function: 0x15ca41f0' }},['concommand'] = {['Run'] = { src = '@lua/includes/modules/concommand.lua', func = 'function: 0x15f16808' },['Remove'] = { src = '@lua/includes/modules/concommand.lua', func = 'function: 0x15f167e0' },['AutoComplete'] = { src = '@lua/includes/modules/concommand.lua', func = 'function: 0x15f16eb8' },['GetTable'] = { src = '@lua/includes/modules/concommand.lua', func = 'function: 0x15f174f0' },['Add'] = { src = '@lua/includes/modules/concommand.lua', func = 'function: 0x15f17550' }},['cvars'] = {['GetConVarCallbacks'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x15e8f6d0' },['OnConVarChanged'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x15e87fb0' },['Number'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x1edf4e90' },['RemoveChangeCallback'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x15f3bd60' },['String'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x15f4ae78' },['AddChangeCallback'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x1edf4f10' },['Bool'] = { src = '@lua/includes/modules/cvars.lua', func = 'function: 0x15f1a3b8' }},['debug'] = {['traceback'] = { src = '=[C]', func = 'function: builtin#135' },['sethook'] = { src = '=[C]', func = 'function: builtin#132' },['getlocal'] = { src = '=[C]', func = 'function: builtin#126' },['getregistry'] = { src = '=[C]', func = 'function: builtin#120' },['Trace'] = { src = '@lua/includes/extensions/debug.lua', func = 'function: 0x1edf4b70' },['getinfo'] = { src = '=[C]', func = 'function: builtin#125' },['setmetatable'] = { src = '=[C]', func = 'function: builtin#122' },['setfenv'] = { src = '=[C]', func = 'function: builtin#124' },['gethook'] = { src = '=[C]', func = 'function: builtin#133' },['debug'] = { src = '=[C]', func = 'function: builtin#134' },['getfenv'] = { src = '=[C]', func = 'function: builtin#123' },['getmetatable'] = { src = '=[C]', func = 'function: builtin#121' },['getupvalue'] = { src = '=[C]', func = 'function: builtin#128' }},['draw'] = {['DrawText'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f48340' },['SimpleTextOutlined'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f3cf70' },['WordBox'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15e8fb18' },['RoundedBox'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f483b8' },['TexturedQuad'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f479f8' },['RoundedBoxEx'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f484c8' },['Text'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15e89ed8' },['NoTexture'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f4f290' },['GetFontHeight'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x1edeea20' },['TextShadow'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f4f230' },['SimpleText'] = { src = '@lua/includes/modules/draw.lua', func = 'function: 0x15f48270' }},['file'] = {['Exists'] = { src = '=[C]', func = 'function: 0x15c97948' },['Write'] = { src = '@lua/includes/extensions/file.lua', func = 'function: 0x1edf3be0' },['Append'] = { src = '@lua/includes/extensions/file.lua', func = 'function: 0x1edf3bf8' },['Time'] = { src = '=[C]', func = 'function: 0x15c97a88' },['Delete'] = { src = '=[C]', func = 'function: 0x15c97a08' },['Size'] = { src = '=[C]', func = 'function: 0x15c97ac8' },['Read'] = { src = '@lua/includes/extensions/file.lua', func = 'function: 0x1edf3bc8' },['Open'] = { src = '=[C]', func = 'function: 0x15c97b08' },['CreateDir'] = { src = '=[C]', func = 'function: 0x15c97a48' },['Find'] = { src = '=[C]', func = 'function: 0x15c979c8' },['IsDir'] = { src = '=[C]', func = 'function: 0x15c97988' }},['hook'] = {['Run'] = { src = '@lua/includes/modules/hook.lua', func = 'function: 0x15f1dd20' },['Remove'] = { src = '@lua/includes/modules/hook.lua', func = 'function: 0x15f1dd00' },['GetTable'] = { src = '@lua/includes/modules/hook.lua', func = 'function: 0x15f1cf00' },['Add'] = { src = '@lua/includes/modules/hook.lua', func = 'function: 0x15f1cf40' },['Call'] = { src = '@lua/includes/modules/hook.lua', func = 'function: 0x15f1dd60' }},['math'] = {['ceil'] = { src = '=[C]', func = 'function: builtin#35' },['tan'] = { src = '=[C]', func = 'function: builtin#41' },['Clamp'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee10868' },['AngleDifference'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37cd0' },['sinh'] = { src = '=[C]', func = 'function: builtin#45' },['BSplinePoint'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee0d698' },['Rand'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee10880' },['ldexp'] = { src = '=[C]', func = 'function: builtin#56' },['Max'] = { src = '=[C]', func = 'function: builtin#58' },['Round'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37c70' },['atan2'] = { src = '=[C]', func = 'function: builtin#53' },['min'] = { src = '=[C]', func = 'function: builtin#57' },['calcBSplineN'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee0d658' },['ApproachAngle'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37ce8' },['exp'] = { src = '=[C]', func = 'function: builtin#38' },['NormalizeAngle'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37cb8' },['randomseed'] = { src = '=[C]', func = 'function: builtin#60' },['rad'] = { src = '=[C]', func = 'function: builtin#51' },['EaseInOut'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee0d628' },['deg'] = { src = '=[C]', func = 'function: builtin#50' },['fmod'] = { src = '=[C]', func = 'function: builtin#55' },['frexp'] = { src = '=[C]', func = 'function: builtin#48' },['log'] = { src = '=[C]', func = 'function: builtin#52' },['random'] = { src = '=[C]', func = 'function: builtin#59' },['cos'] = { src = '=[C]', func = 'function: builtin#40' },['tanh'] = { src = '=[C]', func = 'function: builtin#47' },['sin'] = { src = '=[C]', func = 'function: builtin#39' },['mod'] = { src = '=[C]', func = 'function: builtin#55' },['cosh'] = { src = '=[C]', func = 'function: builtin#46' },['max'] = { src = '=[C]', func = 'function: builtin#58' },['atan'] = { src = '=[C]', func = 'function: builtin#44' },['Distance'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee0f8a8' },['asin'] = { src = '=[C]', func = 'function: builtin#42' },['sqrt'] = { src = '=[C]', func = 'function: builtin#36' },['Approach'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37ca0' },['pow'] = { src = '=[C]', func = 'function: builtin#54' },['BinToInt'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee10690' },['IntToBin'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee0d558' },['acos'] = { src = '=[C]', func = 'function: builtin#43' },['abs'] = { src = '=[C]', func = 'function: builtin#33' },['Min'] = { src = '=[C]', func = 'function: builtin#57' },['floor'] = { src = '=[C]', func = 'function: builtin#34' },['WithIn'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a0e0' },['Dist'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x1ee0f8a8' },['Remap'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37d18' },['TimeFraction'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37d00' },['modf'] = { src = '=[C]', func = 'function: builtin#49' },['Truncate'] = { src = '@lua/includes/extensions/math.lua', func = 'function: 0x15c37c88' },['log10'] = { src = '=[C]', func = 'function: builtin#37' }},['net'] = {['Receive'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f15028' },['WriteInt'] = { src = '=[C]', func = 'function: 0x15c98c70' },['ReadInt'] = { src = '=[C]', func = 'function: 0x15c98cf0' },['SendToServer'] = { src = '=[C]', func = 'function: 0x15c986a0' },['Start'] = { src = '=[C]', func = 'function: 0x15c98250' },['ReadType'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f13a68' },['BytesWritten'] = { src = '=[C]', func = 'function: 0x15c98658' },['WriteBool'] = { src = '=[C]', func = 'function: 0x15c98310' },['WriteAngle'] = { src = '=[C]', func = 'function: 0x15c98450' },['WriteBit'] = { src = '=[C]', func = 'function: 0x15c98310' },['ReadHeader'] = { src = '=[C]', func = 'function: 0x15c98728' },['WriteType'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15c98aa0' },['ReadBit'] = { src = '=[C]', func = 'function: 0x15c98768' },['WriteNormal'] = { src = '=[C]', func = 'function: 0x15c98410' },['WriteUInt'] = { src = '=[C]', func = 'function: 0x15c98cb0' },['ReadString'] = { src = '=[C]', func = 'function: 0x15c98c30' },['ReadMatrix'] = { src = '=[C]', func = 'function: 0x15c98bf0' },['WriteEntity'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f10fd8' },['WriteColor'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f11008' },['ReadTable'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f11050' },['ReadAngle'] = { src = '=[C]', func = 'function: 0x15c98bb0' },['ReadNormal'] = { src = '=[C]', func = 'function: 0x15c98b70' },['ReadBool'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f10fc0' },['Incoming'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f15040' },['ReadFloat'] = { src = '=[C]', func = 'function: 0x15c987a8' },['WriteData'] = { src = '=[C]', func = 'function: 0x15c98390' },['ReadVector'] = { src = '=[C]', func = 'function: 0x15c98b30' },['ReadUInt'] = { src = '=[C]', func = 'function: 0x15c98d30' },['ReadData'] = { src = '=[C]', func = 'function: 0x15c986e8' },['WriteTable'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f11038' },['ReadEntity'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f10ff0' },['WriteVector'] = { src = '=[C]', func = 'function: 0x15c983d0' },['ReadDouble'] = { src = '=[C]', func = 'function: 0x15c987e8' },['WriteDouble'] = { src = '=[C]', func = 'function: 0x15c982d0' },['WriteString'] = { src = '=[C]', func = 'function: 0x15c98350' },['WriteMatrix'] = { src = '=[C]', func = 'function: 0x15c98618' },['ReadColor'] = { src = '@lua/includes/extensions/net.lua', func = 'function: 0x15f11020' },['WriteFloat'] = { src = '=[C]', func = 'function: 0x15c98290' }},['render'] = {['BlurRenderTarget'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x206088b0' },['SuppressEngineLighting'] = { src = '=[C]', func = 'function: 0x15ca1d28' },['SetBlend'] = { src = '=[C]', func = 'function: 0x15ca1f70' },['SetStencilTestMask'] = { src = '=[C]', func = 'function: 0x15ca3038' },['GetFullScreenDepthTexture'] = { src = '=[C]', func = 'function: 0x15ca1098' },['DrawWireframeSphere'] = { src = '=[C]', func = 'function: 0x15ca3978' },['FogMaxDensity'] = { src = '=[C]', func = 'function: 0x15ca3410' },['DrawScreenQuadEx'] = { src = '=[C]', func = 'function: 0x15ca0758' },['GetDXLevel'] = { src = '=[C]', func = 'function: 0x15ca0b38' },['GetSuperFPTex2'] = { src = '=[C]', func = 'function: 0x15ca1ce0' },['SetViewPort'] = { src = '=[C]', func = 'function: 0x15ca1ff0' },['SetStencilWriteMask'] = { src = '=[C]', func = 'function: 0x15ca3080' },['Capture'] = { src = '=[C]', func = 'function: 0x15ca3d20' },['SetStencilCompareFunction'] = { src = '=[C]', func = 'function: 0x15ca2f98' },['SetShadowsDisabled'] = { src = '=[C]', func = 'function: 0x15ca3bf0' },['CopyTexture'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x206074f0' },['MaterialOverrideByIndex'] = { src = '=[C]', func = 'function: 0x15ca38e8' },['Spin'] = { src = '=[C]', func = 'function: 0x15ca3668' },['DrawBox'] = { src = '=[C]', func = 'function: 0x15ca3a08' },['SetShadowColor'] = { src = '=[C]', func = 'function: 0x15ca3b60' },['GetSuperFPTex'] = { src = '=[C]', func = 'function: 0x15ca1c98' },['GetFogColor'] = { src = '=[C]', func = 'function: 0x15ca3388' },['Model'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x206089f0' },['MaterialOverride'] = { src = '=[C]', func = 'function: 0x15ca38a0' },['GetScreenEffectTexture'] = { src = '=[C]', func = 'function: 0x15ca1a08' },['SetShadowDistance'] = { src = '=[C]', func = 'function: 0x15ca3ba8' },['SetMaterial'] = { src = '=[C]', func = 'function: 0x15ca0968' },['GetSmallTex1'] = { src = '=[C]', func = 'function: 0x15ca1c08' },['SetStencilPassOperation'] = { src = '=[C]', func = 'function: 0x15ca2f48' },['FogStart'] = { src = '=[C]', func = 'function: 0x15ca3248' },['AddBeam'] = { src = '=[C]', func = 'function: 0x15ca08e8' },['DrawTextureToScreen'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x20608990' },['FogMode'] = { src = '=[C]', func = 'function: 0x15ca3208' },['BrushMaterialOverride'] = { src = '=[C]', func = 'function: 0x15ca3c38' },['PushCustomClipPlane'] = { src = '=[C]', func = 'function: 0x15ca2180' },['GetPowerOfTwoTexture'] = { src = '=[C]', func = 'function: 0x15ca1270' },['SupportsPixelShaders_1_4'] = { src = '=[C]', func = 'function: 0x15ca0ec0' },['UpdatePowerOfTwoTexture'] = { src = '=[C]', func = 'function: 0x15ca1220' },['GetAmbientLightColor'] = { src = '=[C]', func = 'function: 0x15ca0a38' },['SupportsVertexShaders_2_0'] = { src = '=[C]', func = 'function: 0x15ca0f60' },['StartBeam'] = { src = '=[C]', func = 'function: 0x15ca08a8' },['GetToneMappingScaleLinear'] = { src = '=[C]', func = 'function: 0x15ca3618' },['DrawQuadEasy'] = { src = '=[C]', func = 'function: 0x15ca0688' },['OverrideColorWriteEnable'] = { src = '=[C]', func = 'function: 0x15ca37c8' },['GetFogDistances'] = { src = '=[C]', func = 'function: 0x15ca33c8' },['SetLightingMode'] = { src = '=[C]', func = 'function: 0x15ca3cd8' },['SetStencilZFailOperation'] = { src = '=[C]', func = 'function: 0x15ca2ef8' },['SetLocalModelLights'] = { src = '=[C]', func = 'function: 0x15ca1d78' },['PopFilterMag'] = { src = '=[C]', func = 'function: 0x15ca3da8' },['ModelMaterialOverride'] = { src = '=[C]', func = 'function: 0x15ca3c88' },['FogEnd'] = { src = '=[C]', func = 'function: 0x15ca3288' },['EnableClipping'] = { src = '=[C]', func = 'function: 0x15ca2e18' },['SetScissorRect'] = { src = '=[C]', func = 'function: 0x15ca3498' },['SupportsPixelShaders_2_0'] = { src = '=[C]', func = 'function: 0x15ca0f10' },['ComputeDynamicLighting'] = { src = '=[C]', func = 'function: 0x15ca0a58' },['UpdateRefractTexture'] = { src = '=[C]', func = 'function: 0x15ca1188' },['SetWriteDepthToDestAlpha'] = { src = '=[C]', func = 'function: 0x15ca3ed0' },['DrawSprite'] = { src = '=[C]', func = 'function: 0x15ca0610' },['ResetModelLighting'] = { src = '=[C]', func = 'function: 0x15ca1dc0' },['CullMode'] = { src = '=[C]', func = 'function: 0x15ca3458' },['GetSurfaceColor'] = { src = '=[C]', func = 'function: 0x15ca0af0' },['UpdateFullScreenDepthTexture'] = { src = '=[C]', func = 'function: 0x15ca1040' },['RedownloadAllLightmaps'] = { src = '=[C]', func = 'function: 0x15ca3e80' },['PushRenderTarget'] = { src = '=[C]', func = 'function: 0x15ca1978' },['SetFogZ'] = { src = '=[C]', func = 'function: 0x15ca32c8' },['PushFilterMin'] = { src = '=[C]', func = 'function: 0x15ca3df0' },['SetStencilFailOperation'] = { src = '=[C]', func = 'function: 0x15ca2ea8' },['GetMoBlurTex0'] = { src = '=[C]', func = 'function: 0x15ca1ae8' },['GetMorphTex0'] = { src = '=[C]', func = 'function: 0x15ca1b78' },['SetStencilEnable'] = { src = '=[C]', func = 'function: 0x15ca2e60' },['OverrideDepthEnable'] = { src = '=[C]', func = 'function: 0x15ca3730' },['DrawWireframeBox'] = { src = '=[C]', func = 'function: 0x15ca39c0' },['SetRenderTargetEx'] = { src = '=[C]', func = 'function: 0x15ca1930' },['SetToneMappingScaleLinear'] = { src = '=[C]', func = 'function: 0x15ca35c8' },['ReadPixel'] = { src = '=[C]', func = 'function: 0x15ca36f0' },['GetRenderTarget'] = { src = '=[C]', func = 'function: 0x15ca12c0' },['DepthRange'] = { src = '=[C]', func = 'function: 0x15ca3860' },['GetRefractTexture'] = { src = '=[C]', func = 'function: 0x15ca11d8' },['SetAmbientLight'] = { src = '=[C]', func = 'function: 0x15ca1e50' },['GetFogMode'] = { src = '=[C]', func = 'function: 0x15ca3308' },['PopFilterMin'] = { src = '=[C]', func = 'function: 0x15ca3e38' },['TurnOnToneMapping'] = { src = '=[C]', func = 'function: 0x15ca3580' },['ClearStencilBufferRectangle'] = { src = '=[C]', func = 'function: 0x15ca30c8' },['SupportsHDR'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x15e7ffe0' },['SetGoalToneMappingScale'] = { src = '=[C]', func = 'function: 0x15ca3530' },['GetLightColor'] = { src = '=[C]', func = 'function: 0x15ca09f0' },['PopFlashlightMode'] = { src = '=[C]', func = 'function: 0x15ca3ad0' },['SetLightmapTexture'] = { src = '=[C]', func = 'function: 0x15ca09a8' },['Clear'] = { src = '=[C]', func = 'function: 0x15ca2030' },['FogColor'] = { src = '=[C]', func = 'function: 0x15ca3348' },['RenderView'] = { src = '=[C]', func = 'function: 0x15ca2100' },['ComputeLighting'] = { src = '=[C]', func = 'function: 0x15ca0aa8' },['GetBlend'] = { src = '=[C]', func = 'function: 0x15ca1fb0' },['DrawBeam'] = { src = '=[C]', func = 'function: 0x15ca0868' },['PopRenderTarget'] = { src = '=[C]', func = 'function: 0x15ca19c0' },['ClearStencil'] = { src = '=[C]', func = 'function: 0x15ca3118' },['GetResolvedFullFrameDepth'] = { src = '=[C]', func = 'function: 0x15ca10e8' },['OverrideBlendFunc'] = { src = '=[C]', func = 'function: 0x15ca3818' },['GetSmallTex0'] = { src = '=[C]', func = 'function: 0x15ca1bc0' },['DrawLine'] = { src = '=[C]', func = 'function: 0x15ca3a48' },['PopCustomClipPlane'] = { src = '=[C]', func = 'function: 0x15ca21c8' },['SetRenderTarget'] = { src = '=[C]', func = 'function: 0x15ca12e0' },['SetStencilReferenceValue'] = { src = '=[C]', func = 'function: 0x15ca2fe8' },['ClearBuffersObeyStencil'] = { src = '=[C]', func = 'function: 0x15ca3160' },['GetBloomTex1'] = { src = '=[C]', func = 'function: 0x15ca1aa0' },['SetModelLighting'] = { src = '=[C]', func = 'function: 0x15ca1e08' },['UpdateScreenEffectTexture'] = { src = '=[C]', func = 'function: 0x15ca1138' },['SetColorMaterialIgnoreZ'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x2060a2b8' },['RenderHUD'] = { src = '=[C]', func = 'function: 0x15ca2140' },['SetColorModulation'] = { src = '=[C]', func = 'function: 0x15ca1ee0' },['CopyRenderTargetToTexture'] = { src = '=[C]', func = 'function: 0x15ca20b0' },['ClearRenderTarget'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x15e7ffc8' },['GetColorModulation'] = { src = '=[C]', func = 'function: 0x15ca1f28' },['ResetToneMappingScale'] = { src = '=[C]', func = 'function: 0x15ca34e0' },['PushFlashlightMode'] = { src = '=[C]', func = 'function: 0x15ca3a88' },['MaxTextureHeight'] = { src = '=[C]', func = 'function: 0x15ca0ff8' },['SetLightingOrigin'] = { src = '=[C]', func = 'function: 0x15ca1e98' },['ClearDepth'] = { src = '=[C]', func = 'function: 0x15ca2070' },['DrawSphere'] = { src = '=[C]', func = 'function: 0x15ca3938' },['OverrideAlphaWriteEnable'] = { src = '=[C]', func = 'function: 0x15ca3778' },['PushFilterMag'] = { src = '=[C]', func = 'function: 0x15ca3d60' },['GetBloomTex0'] = { src = '=[C]', func = 'function: 0x15ca1a58' },['SetColorMaterial'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x20607530' },['EndBeam'] = { src = '=[C]', func = 'function: 0x15ca0928' },['CapturePixels'] = { src = '=[C]', func = 'function: 0x15ca36a8' },['GetMoBlurTex1'] = { src = '=[C]', func = 'function: 0x15ca1b30' },['GetMorphTex1'] = { src = '=[C]', func = 'function: 0x15ca1c50' },['SetShadowDirection'] = { src = '=[C]', func = 'function: 0x15ca3b18' },['DrawQuad'] = { src = '=[C]', func = 'function: 0x15ca06d0' },['DrawTextureToScreenRect'] = { src = '@lua/includes/extensions/client/render.lua', func = 'function: 0x206089d0' },['DrawScreenQuad'] = { src = '=[C]', func = 'function: 0x15ca0710' },['PerformFullScreenStencilOperation'] = { src = '=[C]', func = 'function: 0x15ca31b0' },['MaxTextureWidth'] = { src = '=[C]', func = 'function: 0x15ca0fb0' }},['string'] = {['format'] = { src = '=[C]', func = 'function: builtin#87' },['Trim'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1da70' },['Right'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee19548' },['len'] = { src = '=[C]', func = 'function: builtin#73' },['ToMinutesSeconds'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e180' },['gsub'] = { src = '=[C]', func = 'function: builtin#86' },['Replace'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee19568' },['char'] = { src = '=[C]', func = 'function: builtin#75' },['PatternSafe'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1dfb8' },['StartWith'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee173c8' },['Left'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee19528' },['IsEmpty'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b09fc8' },['rep'] = { src = '=[C]', func = 'function: builtin#77' },['TrimLeft'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1dab0' },['Salt'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b09f48' },['reverse'] = { src = '=[C]', func = 'function: builtin#78' },['Implode'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee19a90' },['ToColor'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee17408' },['NiceSize'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1dad0' },['FormattedTime'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e120' },['GetPathFromFilename'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e0f0' },['find'] = { src = '=[C]', func = 'function: builtin#82' },['ExplodeAt'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a0a0' },['SplitAt'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a008' },['Comma'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee17420' },['ToMinutesSecondsMilliseconds'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e160' },['Split'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e0a0' },['gfind'] = { src = '=[C]', func = 'function: builtin#85' },['JavascriptSafe'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1df50' },['IsNumber'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b09f88' },['StripExtension'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e0d8' },['sub'] = { src = '=[C]', func = 'function: builtin#76' },['gmatch'] = { src = '=[C]', func = 'function: builtin#85' },['FromColor'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1db20' },['match'] = { src = '=[C]', func = 'function: builtin#83' },['GetChar'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1db08' },['SetChar'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1daf0' },['ParseURL'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a040' },['GetFileFromFilename'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e108' },['GetExtensionFromFilename'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e0c0' },['NiceTime'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1e1b8' },['TrimRight'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1da90' },['lower'] = { src = '=[C]', func = 'function: builtin#79' },['EndsWith'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee173e8' },['dump'] = { src = '=[C]', func = 'function: builtin#81' },['upper'] = { src = '=[C]', func = 'function: builtin#80' },['Explode'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1dff8' },['byte'] = { src = '=[C]', func = 'function: builtin#74' },['ExplodePattern'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a080' },['ToTable'] = { src = '@lua/includes/extensions/string.lua', func = 'function: 0x1ee1dee8' },['Capitalize'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a0c0' },['HasURL'] = { src = '@addons/core/lua/extensions/sh_init.lua', func = 'function: 0x32b0a028' }},['surface'] = {['DrawText'] = { src = '=[C]', func = 'function: 0x15ca4598' },['SetDrawColor'] = { src = '=[C]', func = 'function: 0x15ca4420' },['SetMaterial'] = { src = '=[C]', func = 'function: 0x15ca4768' },['ScreenWidth'] = { src = '=[C]', func = 'function: 0x15ca45d8' },['SetTexture'] = { src = '=[C]', func = 'function: 0x15ca4728' },['DrawRoundBox'] = { src = '@addons/core/lua/extensions/cl_init.lua', func = 'function: 0x32b0d868' },['CreateFont'] = { src = '=[C]', func = 'function: 0x15ca43a8' },['SetTextPos'] = { src = '=[C]', func = 'function: 0x15ca4558' },['SetFont'] = { src = '=[C]', func = 'function: 0x15ca46a0' },['GetTextSize'] = { src = '=[C]', func = 'function: 0x15ca4660' },['DrawSentence'] = { src = '@addons/core/lua/extensions/cl_init.lua', func = 'function: 0x32b0d838' },['DisableClipping'] = { src = '=[C]', func = 'function: 0x15ca4900' },['GetTextureID'] = { src = '=[C]', func = 'function: 0x15ca46e0' },['ScreenHeight'] = { src = '=[C]', func = 'function: 0x15ca4618' },['SetAlphaMultiplier'] = { src = '=[C]', func = 'function: 0x15ca49a8' },['GetHUDTexture'] = { src = '=[C]', func = 'function: 0x15ca47d0' },['DrawOutlinedRect'] = { src = '=[C]', func = 'function: 0x15ca44a8' },['DrawBox'] = { src = '@addons/core/lua/extensions/cl_init.lua', func = 'function: 0x32b0d850' },['GetTextureSize'] = { src = '=[C]', func = 'function: 0x15ca4788' },['DrawTexturedRectUV'] = { src = '=[C]', func = 'function: 0x15ca4960' },['DrawGradient'] = { src = '@addons/core/lua/extensions/cl_init.lua', func = 'function: 0x32b0d898' },['SetTextColor'] = { src = '=[C]', func = 'function: 0x15ca4510' },['DrawTexturedRect'] = { src = '=[C]', func = 'function: 0x15ca4818' },['PlaySound'] = { src = '=[C]', func = 'function: 0x15ca4880' },['DrawPoly'] = { src = '=[C]', func = 'function: 0x15ca48c0' },['DrawCircle'] = { src = '=[C]', func = 'function: 0x15ca4920' },['DrawTexturedRectRotated'] = { src = '=[C]', func = 'function: 0x15ca4860' },['DrawRect'] = { src = '=[C]', func = 'function: 0x15ca4468' },['DrawLine'] = { src = '=[C]', func = 'function: 0x15ca44f0' },['DrawImage'] = { src = '@addons/core/lua/extensions/cl_init.lua', func = 'function: 0x32b0d880' }},['table'] = {['Empty'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee23ac8' },['HasValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee29a58' },['foreach'] = { src = '=[C]', func = 'function: builtin#89' },['Sanitise'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee2a040' },['CopyFromTo'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee208d8' },['getn'] = { src = '=[C]', func = 'function: builtin#90' },['GetFirstKey'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x15c37288' },['GetWinningKey'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f020' },['ForEach'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f098' },['Reverse'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f080' },['GetFirstValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee21ba0' },['DeSanitise'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee2a058' },['SortByKey'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f1d8' },['KeyFromValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f038' },['maxn'] = { src = '=[C]', func = 'function: builtin#91' },['CollapseKeyValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x15c37220' },['IsSequential'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee29fc8' },['Count'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f1f0' },['Inherit'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee255f8' },['Add'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f1a8' },['Copy'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee252b8' },['GetKeys'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f0b0' },['LowerKeyNames'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x15c37208' },['ToString'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee2a020' },['insert'] = { src = '=[C]', func = 'function: builtin#92' },['sort'] = { src = '=[C]', func = 'function: builtin#95' },['SortByMember'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x15c371f0' },['foreachi'] = { src = '=[C]', func = 'function: builtin#88' },['ClearKeys'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x15c37238' },['ForceInsert'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x15c371d8' },['FindNext'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee21be8' },['Random'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f208' },['GetLastValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee21bd0' },['KeysFromValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f068' },['Merge'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee29a40' },['remove'] = { src = '=[C]', func = 'function: builtin#93' },['SortDesc'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f1c0' },['FindPrev'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee21c00' },['RemoveByValue'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee1f050' },['concat'] = { src = '=[C]', func = 'function: builtin#94' },['GetLastKey'] = { src = '@lua/includes/extensions/table.lua', func = 'function: 0x1ee21bb8' }},['timer'] = {['Exists'] = { src = '=[C]', func = 'function: 0x15c99988' },['UnPause'] = { src = '=[C]', func = 'function: 0x15c99a88' },['Toggle'] = { src = '=[C]', func = 'function: 0x15c99ac8' },['Adjust'] = { src = '=[C]', func = 'function: 0x15c99a08' },['Create'] = { src = '=[C]', func = 'function: 0x15c999a8' },['Destroy'] = { src = '=[C]', func = 'function: 0x15c99d10' },['Stop'] = { src = '=[C]', func = 'function: 0x15c99b08' },['Start'] = { src = '=[C]', func = 'function: 0x15c999e8' },['Remove'] = { src = '=[C]', func = 'function: 0x15c99d50' },['Pause'] = { src = '=[C]', func = 'function: 0x15c99a48' },['RepsLeft'] = { src = '=[C]', func = 'function: 0x15c99dd0' },['TimeLeft'] = { src = '=[C]', func = 'function: 0x15c99d90' },['Simple'] = { src = '=[C]', func = 'function: 0x15c99e10' },['Check'] = { src = '=[C]', func = 'function: 0x15c99b48' },}}

function AC:Init()
	if AC.Loaded then return end
	
	AC.Loaded = true
	AC.Pulse = false
	
	if AC._G.GetGlobalString("ac_netaddress") != "removed" then
		AC.netaddress = AC._G.GetGlobalString("ac_netaddress")
		
		AC._G.SetGlobalString("ac_netaddress", "removed")
	end
	
	AC.Debug["net"]["Incoming"] = { src = util.CRC("@addons/core/lua/anticheat/cl_init.lua"), func = util.CRC(tostring(net.Incoming)) }
	
	if AC._G.gmod.GetGamemode().Name == "Trouble in Terrorist Town" then
		AC.Debug["table"]["HasValue"] = { src = "1430300170", func = "892818572" }
	end
	
	cam = AC._G.cam
	chat = AC._G.chat
	concommand = AC._G.concommand
	cvars = AC._G.cvars
	debug = AC._G.debug
	draw = AC._G.draw
	file = AC._G.file
	hook = AC._G.hook
	math = AC._G.math
	net = AC._G.net
	render = AC._G.render
	require = AC._G.require
	string = AC._G.string
	surface = AC._G.surface
	table = AC._G.table
	timer = AC._G.timer
	umsg = AC._G.umsg
	util = AC._G.util
		
	AC._G.net.Receive(AC.netaddress, function(len)
		AC.Pulse = false
	end)
	
	AC._G.net.Incoming = function( len, ply )
		local i = AC._G.net.ReadHeader()
		local str = AC._G.util.NetworkIDToString(i)
		
		if !str then return end
		
		local func = AC._G.net.Receivers[str:lower()]
		if ( !func ) then return end
		len = len - 16
		
		func(len, ply)
	end
	
	AC:GetDir("addons")
	AC:GetDir("lua")
	AC:CheckFiles()
	
	for k, v in AC._G.pairs(AC.Convars) do
		AC._G.cvars.AddChangeCallback(k, function(_, oVar, nVar)
			if nVar != v or oVar != v then 
				AC:Send(k, nVar)
			end
		end)
	end
	
	for k, _v in AC._G.pairs(AC._G.hook.GetTable()) do
		for v, _k in AC._G.pairs(_v) do
			if !AC.Hooks[k] then
				AC.Hooks[k] = {}
				
				if AC._G.type(v) == "string" then
					if !AC.Hooks[k][v] then
						//AC:Send("hook", "[" .. k .. "][" .. v .. "]")
						AC.Hooks[k][v] = true
					end
				end
			else
				if AC._G.type(v) == "string" then
					if !AC.Hooks[k][v] then
						//AC:Send("hook", "[" .. k .. "][" .. v .. "]")
						AC.Hooks[k][v] = true
					end
				end
			end
		end
	end
	
	AC:Think()
	AC:Override()
	AC:Config()
end

function AC:Send(key, val)
	if AC._G.GetGlobalString("ac_netaddress") != "removed" then
		AC.netaddress = AC._G.GetGlobalString("ac_netaddress")
		
		AC._G.SetGlobalString("ac_netaddress", "removed")
	end
	
	if !AC.netaddress then return end
	
	if AC.netaddress:len() == 0 then
		return
	end
	
	if AC.Sent[key] == val then
		return
	end
	
	AC.Sent[key] = val
	
	AC._G.net.Start(AC.netaddress)
		AC._G.net.WriteString(AC._G.util.Base64Encode(AC._G.tostring(key)))
		AC._G.net.WriteString(AC._G.util.Base64Encode(AC._G.tostring(val)))
	AC._G.net.SendToServer()
	
	AC.Pulse = true
	
	AC._G.timer.Simple(20, function()
		if AC.Pulse then
			AC._G.RunConsoleCommand([[gamemenucommand]], [[quit]])
		end
	end)
end

function AC:GetDir( dir )
	if !AC.Files then AC.Files = {} end
	
	local files, folders = AC._G.file.Find(dir .. "/*", "GAME")
	
	if folders then
		for k, v in AC._G.pairs(folders) do
			AC:GetDir(dir .. "/" .. v)
		end
	end
	
	if files then
		for k, v in AC._G.pairs(files) do
			if v:sub(v:len() - 3, v:len()) == ".lua" then
				AC.Files[dir .. "/" .. v] = 0
			end
		end
	end
end

function AC:Detours()
	if cam != AC._G.cam then
		AC:Send("cam", AC._G.tostring(cam))
		
		cam = AC._G.cam
	end
	if chat != AC._G.chat then
		AC:Send("chat", AC._G.tostring(chat))
		
		chat = AC._G.chat
	end
	if concommand != AC._G.concommand then
		AC:Send("concommand", AC._G.tostring(concommand))
		
		concommand = AC._G.concommand
	end
	if cvars != AC._G.cvars then
		AC:Send("cvars", AC._G.tostring(cvars))
		
		cvars = AC._G.cvars
	end
	if debug != AC._G.debug then
		AC:Send("debug", AC._G.tostring(debug))
		
		debug = AC._G.debug
	end
	if draw != AC._G.draw then
		AC:Send("draw", AC._G.tostring(draw))
		
		draw = AC._G.draw
	end
	if file != AC._G.file then
		AC:Send("file", AC._G.tostring(file))
		
		file = AC._G.file
	end
	if hook != AC._G.hook then
		AC:Send("hook", AC._G.tostring(hook))
		
		hook = AC._G.hook
	end
	if math != AC._G.math then
		AC:Send("math", AC._G.tostring(math))
		
		math = AC._G.math
	end
	if net != AC._G.net then
		AC:Send("net", AC._G.tostring(net))
		
		net = AC._G.net
	end
	if render != AC._G.render then
		AC:Send("render", AC._G.tostring(render))
		
		render = AC._G.render
	end
	if require != AC._G.require then
		AC:Send("require", AC._G.tostring(require))
		
		require = AC._G.require
	end
	if string != AC._G.string then
		AC:Send("string", AC._G.tostring(string))
		
		string = AC._G.string
	end
	if surface != AC._G.surface then
		AC:Send("surface", AC._G.tostring(surface))
		
		surface = AC._G.surface
	end
	if table != AC._G.table then
		AC:Send("table", AC._G.tostring(table))
		
		table = AC._G.table
	end
	if timer != AC._G.timer then
		AC:Send("timer", AC._G.tostring(timer))
		
		timer = AC._G.timer
	end
	if umsg != AC._G.umsg then
		AC:Send("umsg", AC._G.tostring(umsg))
		
		umsg = AC._G.umsg
	end
	if util != AC._G.util then
		AC:Send("util", AC._G.tostring(util))
		
		util = AC._G.util
	end
end

function AC:Override()
	function CreateMaterial(name, shader, table)
		local src = debug.getinfo(2).short_src
		
		print(src)
		
		return AC._G.CreateMaterial(name, shader, table)
	end
	
	function CreateClientConVar(cvarname, default, save, onmenu)
		local src = debug.getinfo(2).short_src
		
		print(src)
		
		return AC._G.CreateClientConVar(cvarname, default, save, onmenu )
	end
end

function AC:Blacklist()
	for k, v in AC._G.pairs(AC.Convars) do
		if AC._G.type(v) != "string" then
			if AC._G.GetConVarNumber(k) != v then
				AC:Send(k, AC._G.GetConVarNumber(k))
			end
		else
			if AC._G.GetConVarString(k) != v then
				AC:Send(k, AC._G.GetConVarString(k))
			end
		end
	end
	
	for _, str in AC._G.pairs(AC.Strings) do
		for hk, _ in AC._G.pairs(AC._G.hook.GetTable()) do
			if hk:lower():find(str) then
				//AC:Send(hk:lower(), str)
			end
		end
	end
	
	local cmds = AC._G.concommand.GetTable()
	for _, str in AC._G.pairs(AC.Strings) do
		for cmd, _ in AC._G.pairs(cmds) do
			if cmd:lower():find("_" .. str) or cmd:lower():find(str .. "_") then
				//AC:Send(cmd:lower(), str)
			end
		end
	end
end

function AC:Source()
	for lib, tbl in AC._G.pairs(AC.Debug) do
		for func, arg in AC._G.pairs(tbl) do
			local info, funt = AC._G.util.CRC(_G.tostring(AC._G.debug.getinfo(_G[lib][func]).source)), AC._G.util.CRC(_G.tostring(AC._G.debug.getinfo(_G[lib][func]).func))
			
			if arg then
				if info != arg.src then
					//AC:Send(lib .. "." .. func, info)
					//print(lib .. "." .. func, info)
				end
				
				if funct != arg.func then
					//AC:Send(lib .. "." .. func, funct)
					//print(lib .. "." .. func, funct)
				end
			end
		end
	end
end

function AC:Config()
	local content = AC._G.file.Read("cfg/config.cfg", "GAME")
	local tbl = AC._G.string.Explode("\n", content)
	
	for _, str in AC._G.pairs(AC.Strings) do
		for _, cmd in AC._G.pairs(tbl) do
			if cmd:lower():find("alias") or cmd:lower():find("bind") then
				if cmd:lower():find("_" .. str) or cmd:lower():find(str .. "_") then
					//AC:Send(cmd:lower(), str)
					print(cmd:lower(), str)
				end
			end
		end
	end
end

function AC:Think()
	AC:Blacklist()
	AC:Detours()
	AC:Source()
	
	if AC._G.GetGlobalString("ac_netaddress") != "removed" then
		AC.netaddress = AC._G.GetGlobalString("ac_netaddress")
		
		AC._G.SetGlobalString("ac_netaddress", "removed")
	end
	
	/*AC:Send("crc", AC._G.util.CRC(AC._G.file.Read("gamemodes/base/gamemode/cl_init.lua", true)))
	AC:Send("crc2", AC._G.util.CRC(AC._G.file.Read("gamemodes/sandbox/gamemode/cl_init.lua", true)))*/
	
	AC._G.timer.Simple(6, function() AC:Think() end)
end

function AC:CheckFiles()
	if AC.Files then
		for k, _ in AC._G.pairs(AC.Files) do
			local tbl = AC._G.string.Explode("\n", AC._G.file.Read(k, true))
			
			for _, str in AC._G.pairs(AC.Strings) do
				for _, str2 in AC._G.pairs(tbl) do
					if AC._G.string.find(str2, str) then
						//print(k, str)
					end
				end
			end
		end
	end
	
	for file, crc in AC._G.pairs(AC.DFiles) do
		if AC._G.file.Exists(file, "GAME") then
			local hash = AC._G.util.CRC(AC._G.file.Read(file, true))
			
			if hash and hash != crc then
				//AC:Send("dfiles", file .. ";" .. hash .. ";" .. crc .. ";" .. AC._G.file.Read(file, true))
			end
		end
	end
end

local _OnEntityCreated, _PlayerBindPress = AC._G.string.Salt(AC._G.math.random(8,32)), AC._G.string.Salt(AC._G.math.random(8,32))

AC._G.hook.Add("OnEntityCreated", _OnEntityCreated, function()
	if !AC.Loaded then
		AC:Init()
	end
end)

AC._G.hook.Add("PlayerBindPress", _PlayerBindPress, function(ply, bind)
	if !AC._G.table.HasValue(AC.Binds, bind) then
		//AC:Send("bind", bind)
		AC._G.table.insert(AC.Binds, bind)
	end
end)
