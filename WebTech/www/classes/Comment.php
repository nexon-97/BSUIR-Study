<?php
	require_once('Template.php');
	require_once('SiteInfo.php');
	
	class Comment extends Template
	{
		private $authorId;
		private $authorName;
		private $authorAvatar;
		private $commentText;
		private $commentDate;
		private $commentId;
		private $showRemoveBtn;
		private $referer;
		
		public function __construct($author, $authorId, $text, $date, $avatar, $commentId = 0, $showRemoveBtn = false, $referer = 'index.php')
		{
			parent::__construct('comment_body');
			
			$this->authorId = $authorId;
			$this->authorName = $author;
			$this->authorAvatar = $avatar;
			$this->commentText = $text;
			$this->commentDate = $date;
			$this->commentId = $commentId;
			$this->showRemoveBtn = $showRemoveBtn;
			$this->referer = $referer;
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('USERNAME', $this->authorName);
			$this->replaceKeywordByText('USERNAME_LINK', SiteInfo::getAuthorLink($this->authorId));
			$this->replaceKeywordByText('USER_AVATAR', $this->authorAvatar);
			$this->replaceKeywordByText('COMMENT_TEXT', $this->commentText);
			$this->replaceKeywordByText('CREATION_DATE', $this->commentDate);
			$this->replaceKeywordByText('REMOVE_BUTTON_DISPLAY', $this->showRemoveBtn ? 'block' : 'none');
			$this->replaceKeywordByText('COMMENT_ID', $this->commentId);
			$this->replaceKeywordByText('REFERER', $this->referer);
		}
	}
?>