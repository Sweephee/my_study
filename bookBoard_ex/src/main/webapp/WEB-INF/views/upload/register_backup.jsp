<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>SB Admin 2 - Bootstrap Admin Theme</title>
    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link href="/resources/vendor/datatables-plugins/dataTables.bootstrap.css" rel="stylesheet">
    <!-- DataTables Responsive CSS -->
    <link href="/resources/vendor/datatables-responsive/dataTables.responsive.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">
    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
</style>
</head>
<body>
<%@include file="../includes/header-logout.jsp" %>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
	
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Register</div>
			<div class="panel-body">
				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>제목</label><input class="form-control" name="title" required>
					</div>
					<div class="form-gorup">
						<label>내용</label>
						<textarea class="form-control" rows="10" name="content"></textarea>
					</div>
					<div class="form-gorup">
						<label>작성자</label>
						<input class="form-control" name="user_id" value="" readonly>
					</div>
					<div class="margin_top5px" style="margin-top:15px"></div>
					<button type="submit" class="btn btn-default">Submit Button</button>
					<button type="reset" class="btn btn-default">Reset Button</button>
					
				</form>
			</div>
		</div>
	</div>
</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">File Attach</div>
			
			<div class="panel-body">
				<div class="form-group uploadDiv">
				<input type="file" name="uploadFile" multiple>
				</div>
				<div class="uploadResult">
					<ul>
				
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
$(".uploadResult").on("click", "button", function(e) {
	console.log("delete file");
	
	var targetFile = $(this).data("file");
	var type = $(this).data("type");
	
	var targetLi =$(this).closest("li");
	
	$.ajax({
		url: '/upload/deleteFile',
		data: {fileName : targetFile, type: type},
		dataType: 'text',
		type: 'POST',
		success: function(result) {
			alert(result);
			targetLi.remove();
		}
	});
	
});
</script>

<%@include file="../includes/footer.jsp" %>
<script>
	$(document).ready(function(e) {
		
		var formObj = $("form[role='form']");
		$("button[type='submit']").on("click", function(e) { //서브밋클릭 시 첨부파일관련 처리가 되도록 막는것 
			
			e.preventDefault();
			console.log("submit clicked");
		});
		
		function showUploadResult(uploadResultArr) {
			
			if(!uploadResultArr || uploadResultArr.length == 0) { return; }
			var uploadUL = $(".uploadResult ul");
			var str = "";
			$(uploadResultArr).each(function(i, obj) {
				
				if(obj.image) {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
					
					str += "<li><div>";
					str += "<span>"+obj.fileName+"</span>";
					str += "<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/upload/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
					
				}else {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li><div>";
					str += "<span>"+ obj.fileName + "</span>";
					str += "<button type='button' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/user/default-user.png'></a>";
					str += "</div>";
					str += "</li>";
				}
				
			});
			uploadUL.append(str);
		}
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5MB
		
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할수 없습니다.");
				return false;
			}
			return true;
		}
		
		$("input[type='file']").change(function(e) {
			
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			for(var i = 0; i < files.length; i++) {
				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			$.ajax({
				url:'/upload/uploadAjaxAction',
				processData: false,
				contentType: false,
				data: formData, 
				type: 'POST',
				dataType: 'json',
				success: function(result) {
					console.log(result);
					showUploadResult(result);
				}
			});
		});
		
		
	});
</script>
</body>
</html>