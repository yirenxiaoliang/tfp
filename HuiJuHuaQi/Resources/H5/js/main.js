
$(function(){
	
	//手指闪闪
	function showFinger1(){
		$(".page").find(".hand:eq(0)").show().siblings().hide();
		setTimeout(showFinger2,200);
	}
	function showFinger2(){
		$(".page").find(".hand:eq(1)").show().siblings().hide();
		setTimeout(showFinger3,200);
	}
	function showFinger3(){
		$(".page").find(".hand:eq(2)").show().siblings().hide();
		setTimeout(showFinger1,200);
	}
	showFinger1();
	
	//第一个页面的提示语展现出来
	$(".help1 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help1 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	 
	 $(".help2 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help2 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help3 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help3 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	 
	 $(".help4 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help4 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help5 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help5 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help6 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help6 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help7 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help7 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help8 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help8 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help9 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help9 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help10 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help10 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help11 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help11 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help12 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help12 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help12 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help12 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	
	$(".help13 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help13 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	
	$(".help14 .info1").show('slow');
	
	
	
	// 手机功能页面切换
	$(".help14 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help15 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help15 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help16 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help16 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
	
	$(".help17 .info1").show('slow');
	
	// 手机功能页面切换
	$(".help17 .guide").click(function(){
		var nextindex=$(this).parent().index();
		nextindex++;
		$(this).parent().hide();
		$(this).parent().parent().children().eq(nextindex).show().children(".info").show('slow');
	});
});