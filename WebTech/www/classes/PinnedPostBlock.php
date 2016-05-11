<?php
	require_once('Template.php');
	require_once('Database.php');

	class PinnedPostBlock extends Template
	{
		protected $postId;
		protected $postTitle;
		protected $postDate;
		protected $postDesc;
		protected $postImage;
		protected $postAuthor;
		protected $postAuthorLink;
		
		public function __construct()
		{
			parent::__construct('pinnedPostLayout');
			
			$pinnedPostId = 0;
			$jsonText = Utils::readDataFile('PinnedPostId.json');
			if ($jsonText !== false)
			{
				$jsonDecoded = json_decode($jsonText, true);
				$pinnedPostId = $jsonDecoded['id'];
			}
			
			$db = new Database('nexonlab');
			$postInfo = $db->SelectConditional('blog_entries', '*', 'id = '.$pinnedPostId);
			if (count($postInfo) == 1)
			{
				$postInfo = $postInfo[0];
				
				$this->postId = $postInfo['id'];
				$this->postTitle = $postInfo['title'];
				$this->postDate = $postInfo['creation_date'];
				$this->postDesc = $postInfo['short_desc'];
				$this->postImage = $postInfo['image'];
				
				$authorInfo = $db->SelectConditional('user_profiles', 'nickname', 'id = '.$postInfo['author']);
				if (count($authorInfo) == 1)
				{
					$this->postAuthor = $authorInfo[0]['nickname'];
					$this->postAuthorLink = SiteInfo::getAuthorLink($postInfo['author']);
				}
			}
		}
		
		protected function handleKeywords()
		{
			$this->replaceKeywordByText('TITLE', $this->postTitle);
			$this->replaceKeywordByText('POST_LINK', 'post.php?id='.$this->postId);
			$this->replaceKeywordByText('DESCRIPTION', $this->postDesc);
			$this->replaceKeywordByText('IMAGE', $this->postImage);
			$this->replaceKeywordByText('POST_DATE', $this->postDate);
			$this->replaceKeywordByText('USERNAME', $this->postAuthor);
			$this->replaceKeywordByText('USER_LINK', $this->postAuthorLink);
		}
	}
?>