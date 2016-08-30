Widget {
    property Array    options:  []
    property Function callback: nil
    property Int      hl:       nil
    function prime() {
        @ctime = Time.new
    }
    function draw(vg)
    {
        n  = options.length
        dy = h/n

        if self.hl.nil?
            self.hl = 0   if self.y == 0
            self.hl = n-1 if self.y != 0
        end

        (0...n).each do |row|
            vg.path do |v|
                v.rect(0, row*dy, w, dy+1)
                v.fill_color Theme::BankEven     if row%2 == 0
                v.fill_color Theme::BankOdd      if row%2 == 1
                v.fill_color Theme::ButtonActive if hl == row
                v.fill
            end
        end


        text_color = Theme::TextColor
        vg.font_face("bold")
        vg.font_size h*0.8/n
        vg.text_align NVG::ALIGN_LEFT | NVG::ALIGN_MIDDLE
        vg.fill_color text_color

        pad  = 1/64
        options.each_with_index do |opt, i|
            vg.text(3+w*pad*2,dy*(i+0.5),opt.upcase)
        end
    }

    function onMousePress(ev) {
        #Allow Tap within 200ms
        return if @ctime && Time.new-@ctime < 0.200
        n   = options.length
        opt = (n*(ev.pos.y-global_y)/h).to_i
        xsp = (ev.pos.x-global_x)/w
        inx = 0 <= xsp && xsp <= 1

        callback.call opt if callback && inx
        rt = self.root
        rt.ego_death self
    }

    function onMouseRelease(ev) { onMousePress(ev) }
    function onMouseMove(ev)
    {
        n   = options.length
        opt = (n*(ev.pos.y-global_y)/h).to_i
        self.hl = opt
        damage_self
    }
}
