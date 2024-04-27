module Watermark
  class ViewHook < Redmine::Hook::ViewListener
    def view_layouts_base_body_bottom(context={})
      path = Redmine::CodesetUtil.replace_invalid_utf8(context[:request].path_info);

      html = "\n<!-- [watermark plugin] path:#{path} -->\n"
      html << stylesheet_link_tag("watermark", plugin: "redmine_watermark")


      return html if Setting.plugin_redmine_watermark['watermark_enable'] != 'on'

      html << "
          <script type=\"text/javascript\">\n
          !function(t,e){'object'==typeof exports&&'undefined'!=typeof module?module.exports=e():'function'==typeof define&&define.amd?define(e):t.watermark=e()}(this,(function(){'use strict';return function(){function t(){}return t.create=function(t){var e=this;this.deleteWatermark(),this.config=t,this.setWatermark(this.config),this.observer=new MutationObserver((function(t){for(var r=0,a=t;r<a.length;r++){var o=a[r];o.target===e.watermark&&e.setWatermark(e.config);for(var n=0,i=Array.from(o.removedNodes);n<i.length;n++){i[n]===e.watermark&&e.setWatermark(e.config)}}})),this.observer.observe(document.body,{childList:!0,subtree:!0,attributes:!0})},t.setWatermark=function(t){this.watermark&&this.watermark.remove();var e='1.23452384164.123412416';null!==document.getElementById(e)&&document.body.removeChild(document.getElementById(e));var r=document.createElement('canvas');r.width=300,r.height=230;var a=r.getContext('2d');a.rotate(-20*Math.PI/180),a.font='14px Vedana',a.fillStyle=t.fontColorWhite?'rgba(255, 255, 255)':'rgba(200, 200, 200)',a.textBaseline='middle','dark'!=t.mode&&(a.globalAlpha=.3,a.fillText(t.content,0,60),a.fillText(t.customText||'',0,76)),a.fillStyle=t.fontColorWhite?'rgba(255, 255, 255)':'rgba(0,0,0)',a.globalAlpha=.005;var o=window.location.host,n=(new Date).toLocaleString(),i=t.secretContent||t.content;a.fillText(''.concat(i,'-').concat(i),0,92);for(var s=1;s<6;s++)a.fillText(''.concat(n,'-').concat(n),0,60+48*s),a.fillText(''.concat(i,'-').concat(i),0,60+48*s+16),a.fillText(''.concat(o,'-').concat(o),0,60+48*s+32);return this.watermark=document.createElement('div'),this.watermark.id=e,this.watermark.style.pointerEvents='none',this.watermark.style.top='15px',this.watermark.style.left='15px',this.watermark.style.position='fixed',this.watermark.style.zIndex='10000000',this.watermark.style.width='5000px',this.watermark.style.height='3000px',this.watermark.style.background='url('.concat(r.toDataURL('image/png'),') left top repeat'),document.body.appendChild(this.watermark),e},t.deleteWatermark=function(){this.observer&&this.observer.disconnect(),this.watermark&&this.watermark.remove()},t}()}));     
          $(window).ready(function() {
            Watermark.create({
              content: '#{User.current.name} #{User.current.id}}',
              secretContent: '#{User.current.id} #{format_date(Time.current)}', // 可选，暗水印内容，不填默认使用content
              mode: 'light', // 可选，切换只使用暗水印模式
              customText: '#{Setting.plugin_redmine_watermark['watermark_custom_text']}',
              fontColorWhite: false, // 可选，字体颜色, 如果界面是深色主题，使用固定值true
            });
          });
          "
      html << "\n</script>\n"
      return html
    end
  end
end
