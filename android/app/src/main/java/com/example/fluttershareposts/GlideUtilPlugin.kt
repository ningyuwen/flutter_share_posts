package com.example.fluttershareposts

import android.content.Context
import android.widget.ImageView
import com.bumptech.glide.Glide
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel


object GlideUtilPlugin {
    /** Channel名称  **/
    private const val ChannelName = "aduning/showPicFromGlide"

    /**
     * 注册Toast插件
     * @param context 上下文对象
     * @param messenger 数据信息交流对象
     */
    @JvmStatic
    fun register(context: Context, messenger: BinaryMessenger) = MethodChannel(messenger, ChannelName).setMethodCallHandler { methodCall, result ->
        when (methodCall.method) {
            "showPic" -> showImageFromGlide(context, methodCall.argument<String>("url")!!,
                    methodCall.argument<Int>("width")!!, methodCall.argument<Int>("height")!!)
        }
        result.success(null) //没有返回值，所以直接返回为null
    }

    private fun showImageFromGlide(context: Context, url: String, width: Int, height: Int) {
        var imageView = ImageView(context)
        val lp = imageView.layoutParams
        lp.width = width
        lp.height = height
        imageView.layoutParams = lp

        Glide.with(context).load(url).into(imageView)
    }

}